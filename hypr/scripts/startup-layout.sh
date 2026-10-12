#!/bin/bash
# goat: rebuild the saved startup layout.
#
# Usage: startup-layout.sh [work|off|auto]   (default: auto)
#
#   work, DP-2 / workspace 2:   Slack   | ChatGPT | Discord
#                                       | foot    |
#   work, DP-1 / workspace 10:  Claude       | Zen
#                               Claude Code  |
#
#   off,  DP-2 / workspace 2:   Discord | ChatGPT   (Slack is closed)
#   off,  DP-1 / workspace 10:  Claude | Zen
#                               foot   |            (Claude Code stays hidden)
#
# auto picks off on weekends and on weekdays before 6 AM or from 7 PM
# (local time), and work otherwise.
#
# Workspace 2 tiles with dwindle: apps open one at a time with the window to
# split focused first, and Omarchy's force_split = 2 puts each new window to
# the right of or below it. Sizes are set through the left/top windows,
# because an exact resize on a right/bottom tile moves the wrong edge.
#
# Workspace 10 scrolls (see workspaces.lua): each new window opens as a column
# to the right of the focused one, stack() tucks it under the column to its
# left, and widths are fractions of the screen.

dispatch() { hyprctl dispatch "$1" >/dev/null; }

# Address of the first window with this class, preferring tiled ones (skips
# floating splash or updater windows that share the class).
addr_of() {
  hyprctl clients -j | jq -r --arg c "$1" \
    'first((.[] | select(.class == $c and .floating == false)), (.[] | select(.class == $c)) | .address) // empty'
}

current_ws() { hyprctl activeworkspace -j | jq -r '.name'; }

mode=${1:-auto}
if [[ $mode == auto ]]; then
  read -r dow hour < <(date '+%u %H')
  hour=$((10#$hour))
  if (( dow >= 6 || hour < 6 || hour >= 19 )); then mode=off; else mode=work; fi
fi

# Off-work never shows Slack: quit it, and wait up to 5s for its window to go.
if [[ $mode == off ]] && pgrep -x slack >/dev/null; then
  pkill -x slack
  for _ in $(seq 25); do
    [[ -z $(addr_of slack) ]] && break
    sleep 0.2
  done
fi

# Running layout windows are never closed or relaunched. To rebuild the layout,
# they're first parked on a hidden special workspace (tiled, not fullscreen),
# then open() moves each back next to the focused window, like a fresh launch.
LAYOUT_CLASSES=(slack chatgpt discord foot com.anthropic.Claude zen org.omarchy.agent)
for class in "${LAYOUT_CLASSES[@]}"; do
  addr=$(addr_of "$class")
  [[ -z $addr ]] && continue
  state=$(hyprctl clients -j | jq -r --arg a "$addr" '.[] | select(.address == $a) | "\(.floating) \(.fullscreen)"')
  read -r floating fullscreen <<<"$state"
  case $fullscreen in
    1) dispatch "hl.dsp.window.fullscreen({ mode = \"maximized\", window = \"address:$addr\" })" ;;
    2|3) dispatch "hl.dsp.window.fullscreen({ mode = \"fullscreen\", window = \"address:$addr\" })" ;;
  esac
  [[ $floating == true ]] && dispatch "hl.dsp.window.float({ action = \"toggle\", window = \"address:$addr\" })"
  dispatch "hl.dsp.window.move({ workspace = \"special:layout-stash\", follow = false, window = \"address:$addr\" })"
done

# Bring back the parked $1 window, or launch $2 if none is open; for a launch,
# wait up to 90s for the window to appear.
open() {
  local class=$1 cmd=$2 addr
  addr=$(addr_of "$class")
  if [[ -n $addr ]]; then
    dispatch "hl.dsp.window.move({ workspace = \"$(current_ws)\", follow = false, window = \"address:$addr\" })"
    sleep 0.2
  else
    setsid uwsm-app -- $cmd >/dev/null 2>&1 &
    for _ in $(seq 180); do
      addr=$(addr_of "$class")
      [[ -n $addr ]] && break
      sleep 0.5
    done
    sleep 1
  fi
  echo "$addr"
}

focus() { [[ -n $1 ]] && dispatch "hl.dsp.focus({ window = \"address:$1\" })"; }

resize() {
  [[ -n $1 ]] && dispatch "hl.dsp.window.resize({ x = $2, y = $3, relative = false, window = \"address:$1\" })"
}

height_of() { hyprctl clients -j | jq -r --arg a "$1" '.[] | select(.address == $a) | .size[1]'; }

# Scrolling-layout helpers for workspace 10.
stack() { [[ -n $1 ]] && focus "$1" && dispatch 'hl.dsp.window.move({ direction = "l" })'; }
column_width() { [[ -n $1 ]] && focus "$1" && dispatch "hl.dsp.layout(\"colresize $2\")"; }
set_height() {
  [[ -n $1 ]] || return
  dispatch "hl.dsp.window.resize({ x = 0, y = $(( $2 - $(height_of "$1") )), relative = true, window = \"address:$1\" })"
}

# DP-2 / workspace 2
dispatch 'hl.dsp.focus({ workspace = "2" })'
if [[ $mode == off ]]; then
  discord=$(open discord discord)
  focus "$discord"; chatgpt=$(open chatgpt chatgpt)
  resize "$discord" 1377 "$(height_of "$discord")"
else
  slack=$(open slack slack)
  focus "$slack"; chatgpt=$(open chatgpt chatgpt)
  # Narrow Slack for now so ChatGPT is wider than tall and Discord splits beside it.
  resize "$slack" 400 "$(height_of "$slack")"
  focus "$chatgpt"; discord=$(open discord discord)
  focus "$chatgpt"; foot=$(open foot foot)
  resize "$slack" 1074 "$(height_of "$slack")"
  resize "$chatgpt" 584 860
fi

# DP-1 / workspace 10: Claude with a second app under it, Zen to the right.
dispatch 'hl.dsp.focus({ workspace = "10" })'
claude=$(open com.anthropic.Claude claude-desktop)
focus "$claude"; zen=$(open zen zen-browser)
if [[ $mode == off ]]; then
  focus "$claude"; under=$(open foot foot)
  stack "$under"
  column_width "$claude" 0.324   # about 606px
  set_height "$claude" 873
else
  focus "$claude"; under=$(open org.omarchy.agent "omarchy agent")
  stack "$under"
  column_width "$claude" 0.332   # about 622px
  set_height "$claude" 469
fi

dispatch 'hl.dsp.focus({ workspace = "10" })'
