#!/bin/bash

# Install goat, a look-and-feel system for Omarchy.
#
#   ./install.sh           install or update everything (safe to re-run)
#   ./install.sh --export  save this machine's bar layout, shell settings and
#                          plugin list back into the repo
#
# Everything is linked back to this repo, so keep it where you cloned it and
# edit files here.

set -euo pipefail
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/lib.sh"

SHELL_JSON="$OMARCHY_CONFIG/shell.json"
SHELL_TOML="$OMARCHY_CONFIG/shell.toml"
PLUGINS_LIST="$REPO/shell/plugins.json"

require() {
  local missing=() cmd
  for cmd in omarchy jq python3 curl; do
    command -v "$cmd" >/dev/null || missing+=("$cmd")
  done
  [[ -d /usr/share/icons/Yaru ]] || missing+=("yaru-icon-theme")
  if (( ${#missing[@]} )); then
    echo "Missing: ${missing[*]}. goat needs an Omarchy system." >&2
    exit 1
  fi
}

# goat is laid out for two 1920x1080 monitors (see hypr/monitors.lua). Other
# setups still install; they just get a heads-up about what to adjust.
check_monitors() {
  local monitors
  monitors=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | "\(.name) \(.width)x\(.height)"' | sort | paste -sd' ')
  if [[ $monitors != "DP-1 1920x1080 DP-2 1920x1080" ]]; then
    echo "Note: goat is laid out for two 1920x1080 monitors (DP-1 left, DP-2 right)." >&2
    echo "      Found: ${monitors:-none}. Adjust hypr/monitors.lua and hypr/workspaces.lua." >&2
  fi
}

link_all() {
  step "Linking goat into ~/.config"
  local src dest
  while read -r src dest; do
    link "$src" "$dest"
    echo "  $dest"
  done < <(goat_links)
}

build_icons() {
  step "Building the goat-cream folder icons"
  python3 "$REPO/icons/build.py"
  gtk-update-icon-cache -q -f -t "$REPO/icons/goat-cream" 2>/dev/null || true
}

install_plugins() {
  step "Installing shell plugins"
  local id url
  while IFS=$'\t' read -r id url; do
    if [[ -e $OMARCHY_CONFIG/plugins/$id ]]; then
      echo "  $id already installed"
    else
      omarchy plugin add "$url" --yes
    fi
  done < <(jq -r '.[] | [.id, .url] | @tsv' "$PLUGINS_LIST")
}

restore_shell() {
  step "Restoring bar layout and shell settings"
  if [[ -f $SHELL_JSON ]]; then
    cp "$SHELL_JSON" "$SHELL_JSON.goat-bak"
    # Saved settings win; keys the snapshot doesn't mention are kept.
    jq -s '.[0] * .[1]' "$SHELL_JSON.goat-bak" "$REPO/shell/shell.json" >"$SHELL_JSON"
  else
    cp "$REPO/shell/shell.json" "$SHELL_JSON"
  fi
  [[ -f $SHELL_TOML ]] && cp "$SHELL_TOML" "$SHELL_TOML.goat-bak"
  cp "$REPO/shell/shell.toml" "$SHELL_TOML"
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
}

reload_hyprland() {
  step "Reloading Hyprland"
  hyprctl reload >/dev/null
  local errors
  errors=$(hyprctl configerrors)
  if [[ -n ${errors//[[:space:]]/} ]]; then
    echo "$errors" >&2
  fi
}

start_daynight() {
  step "Starting the day/night wallpaper daemon"
  pkill -f "$REPO/daynight/daynight daemon" 2>/dev/null || true
  bash "$REPO/hooks/post-boot"
}

apply_theme() {
  # Runs the goat theme-set hook too, which themes Zen and GTK apps.
  step "Applying the goat theme"
  omarchy theme set goat
}

export_settings() {
  step "Saving shell settings into the repo"
  cp "$SHELL_JSON" "$REPO/shell/shell.json"
  cp "$SHELL_TOML" "$REPO/shell/shell.toml"

  step "Saving the plugin list"
  local dir id url entries=()
  for dir in "$OMARCHY_CONFIG"/plugins/*/; do
    dir=${dir%/}
    [[ -f $dir/manifest.json ]] || continue
    # Plugins that live in this repo are linked, not installed from git.
    [[ $(realpath "$dir") == "$REPO"/* ]] && continue
    id=$(jq -r '.id' "$dir/manifest.json")
    url=$(git -C "$dir" remote get-url origin 2>/dev/null || true)
    if [[ -z $url ]]; then
      echo "  skipped $id: no git remote" >&2
      continue
    fi
    echo "  $id"
    entries+=("$(jq -cn --arg id "$id" --arg url "$url" '{id: $id, url: $url}')")
  done
  printf '%s\n' "${entries[@]}" | jq -s '.' >"$PLUGINS_LIST"
}

case "${1:-}" in
  --export)
    export_settings
    ;;
  "")
    require
    check_monitors
    link_all
    build_icons
    install_plugins
    restore_shell
    reload_hyprland
    start_daynight
    apply_theme
    step "goat is installed. Restart Zen and GTK apps to see their new colors."
    ;;
  *)
    echo "Usage: ./install.sh [--export]" >&2
    exit 1
    ;;
esac
