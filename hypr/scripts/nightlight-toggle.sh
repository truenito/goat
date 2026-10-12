#!/bin/bash
# goat: nightlight toggle with a milder temperature than Omarchy's stock 4000K.
# Lower = warmer/stronger. Keep below 6000 so the bar still shows it as on.
ON_TEMP=5500
OFF_TEMP=6500

if ! pgrep -x hyprsunset >/dev/null; then
  setsid uwsm-app -- hyprsunset &
fi

current_temp() {
  hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+' | head -n1
}

CURRENT_TEMP=$(current_temp)
if [[ -z $CURRENT_TEMP || $CURRENT_TEMP == $OFF_TEMP ]]; then
  TARGET_TEMP=$ON_TEMP
else
  TARGET_TEMP=$OFF_TEMP
fi

# A freshly-started hyprsunset applies its default at the end of boot, so resend until it sticks
for _ in {1..10}; do
  hyprctl hyprsunset temperature $TARGET_TEMP >/dev/null 2>&1
  sleep 0.2
  [[ $(current_temp) == "$TARGET_TEMP" ]] && break
done

omarchy-shell -q nightlight refresh
