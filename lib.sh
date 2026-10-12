# Shared by install.sh and uninstall.sh. Source it; don't run it.

GOAT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"
OMARCHY_CONFIG="$CONFIG/omarchy"

# Everything goat installs is a symlink back into this repo, so the repo stays
# the single place to edit. One "repo-path  target" pair per line.
goat_links() {
  cat <<EOF
theme                             $OMARCHY_CONFIG/themes/goat
icons/Goat-Cream                  $HOME/.local/share/icons/Goat-Cream
shell/plugins/gvbrl.notifications $OMARCHY_CONFIG/plugins/gvbrl.notifications
hooks/post-boot                   $OMARCHY_CONFIG/hooks/post-boot.d/goat
hooks/theme-set                   $OMARCHY_CONFIG/hooks/theme-set.d/goat
hypr/hyprland.lua                 $CONFIG/hypr/hyprland.lua
hypr/monitors.lua                 $CONFIG/hypr/monitors.lua
hypr/autostart.lua                $CONFIG/hypr/autostart.lua
hypr/bindings.lua                 $CONFIG/hypr/bindings.lua
hypr/looknfeel.lua                $CONFIG/hypr/looknfeel.lua
hypr/workspaces.lua               $CONFIG/hypr/workspaces.lua
hypr/scripts                      $CONFIG/hypr/scripts
EOF
}

step() {
  printf '\n==> %s\n' "$*"
}

# Point $2 at $GOAT/$1. A real file already there is kept as $2.goat-bak.
link() {
  local src="$GOAT/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e $dest && ! -L $dest ]]; then
    mv "$dest" "$dest.goat-bak"
    echo "  kept your $dest as $dest.goat-bak"
  fi
  ln -sfn "$src" "$dest"
}

# Remove $1 if it links into this repo, and put back what link() set aside.
unlink_goat() {
  local dest="$1"
  [[ -L $dest && $(readlink "$dest") == "$GOAT"/* ]] || return 0
  rm "$dest"
  [[ -e $dest.goat-bak ]] && mv "$dest.goat-bak" "$dest"
  return 0
}
