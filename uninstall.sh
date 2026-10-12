#!/bin/bash

# Remove goat: unlink everything, put back the files it set aside, stop the
# wallpaper daemon, and delete the app styles it generated.
#
# Shell plugins installed from git and your bar layout are left in place;
# remove plugins with `omarchy plugin remove <id>`.

set -uo pipefail
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/lib.sh"

step "Stopping the day/night wallpaper daemon"
pkill -f "$GOAT/daynight/daynight daemon" 2>/dev/null
rm -f "$HOME/.local/state/omarchy/goat-daynight.phase"

step "Removing generated Zen and GTK styles"
"$GOAT/harmony/harmony" --clean

step "Unlinking goat"
while read -r _ dest; do
  unlink_goat "$dest"
done < <(goat_links)

hyprctl reload >/dev/null 2>&1
step "goat removed. Pick another theme with: omarchy theme set <name>"
