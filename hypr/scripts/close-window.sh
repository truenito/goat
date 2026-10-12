#!/bin/bash
# goat: Super+W. Close the focused window, but fully quit Steam when it's a
# Steam window; otherwise Steam just hides in the background with no tray icon.

class=$(hyprctl activewindow -j | jq -r '.class // empty')

if [ "$class" = "steam" ]; then
  steam -shutdown >/dev/null 2>&1 &
else
  hyprctl dispatch 'hl.dsp.window.close()' >/dev/null
fi
