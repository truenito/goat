#!/bin/bash
# goat: rebuild the saved startup layout.
#
# Usage: startup-layout.sh [work|off|auto]   (default: auto)
#
#   work, DP-2 / workspace 2:  Slack   | ChatGPT | Discord
#                                      | foot    |
#   off,  DP-2 / workspace 2:  Discord | ChatGPT   (Slack is closed; a running
#                                                  foot stays hidden in the stash)
#   both, DP-1 / workspace 10: Claude       | Zen
#                              Claude Code  |
#
# auto picks off on weekends and on weekdays before 6 AM or from 7 PM
# (local time), and work otherwise.
#
# Apps open one at a time with the window to split focused first. Omarchy's
# dwindle uses force_split = 2, so each new window lands to the right of or
# below the focused one. Sizes are then set through the left/top windows,
# because an exact resize on a right/bottom tile moves the wrong edge.

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

# DP-2 / workspace 2
dispatch 'hl.dsp.focus({ workspace = "2" })'
if [[ $mode == off ]]; then
  discord=$(open discord discord)
  focus "$discord"; chatgpt=$(open chatgpt chatgpt)
  resize "$discord" 1074 "$(height_of "$discord")"
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

# DP-1 / workspace 10
dispatch 'hl.dsp.focus({ workspace = "10" })'
claude=$(open com.anthropic.Claude claude-desktop)
focus "$claude"; zen=$(open zen zen-browser)
focus "$claude"; agent=$(open org.omarchy.agent "omarchy agent")
resize "$claude" 622 469

dispatch 'hl.dsp.focus({ workspace = "10" })'
