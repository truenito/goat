#!/bin/bash
# goat: nightlight toggle with a milder temperature than Omarchy's stock 4000K.
# Lower = warmer/stronger. Keep below 6000 so the bar still shows it as on.
ON_TEMP=5500
OFF_TEMP=6500

current_temp() {
  hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+' | head -n1
}

# Start hyprsunset if needed and wait (up to 2s) until it answers.
if ! pgrep -x hyprsunset >/dev/null; then
  setsid uwsm-app -- hyprsunset >/dev/null 2>&1 &
  for _ in {1..20}; do
    [[ -n $(current_temp) ]] && break
    sleep 0.1
  done
fi

# Only our warm temperature counts as on. A fresh hyprsunset reports a
# placeholder (1000) and Omarchy's day value is 6500; both mean off.
if [[ $(current_temp) == "$ON_TEMP" ]]; then
  TARGET_TEMP=$OFF_TEMP
else
  TARGET_TEMP=$ON_TEMP
fi

# A freshly-started hyprsunset applies its default at the end of boot, so resend until it sticks
for _ in {1..10}; do
  hyprctl hyprsunset temperature $TARGET_TEMP >/dev/null 2>&1
  sleep 0.2
  [[ $(current_temp) == "$TARGET_TEMP" ]] && break
done

omarchy-shell -q nightlight refresh
