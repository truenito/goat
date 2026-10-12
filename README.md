# Goat

*A quiet mountain look and feel for [Omarchy](https://omarchy.org/), by gvbrl.*

Above the tree line the fog rolls in slowly. The pines go soft and grey, and
somewhere on the ridge a goat stands perfectly still, sure-footed and in no
hurry at all. Goat is that moment kept on your desktop: calm, unhurried, a
little old-fashioned in the best way.

Goat is more than a colour theme. It's the whole desktop: palette and
wallpapers, folder icons, browser and app styling, the status bar and its
plugins, how windows tile, and the hotkeys.

- **Dark walnut** backgrounds, deep and warm like oiled wood
- **Warm cream** text, soft and luxurious
- **Light-brown and larch-gold** highlights, and cream folders
- **Deep jade** window borders and focus rings, like polished stone on walnut
- **A grainy, retro fog** in the wallpapers, which follow the sun: soft mist by
  day, silver dusk haze by night
- **Frosted glass**: unfocused windows soften slightly over a blur

## Built for

This iteration of goat is laid out for **two 1920×1080 monitors side by side**:

| Output | Position | Role | Workspace |
|---|---|---|---|
| `DP-1` | left, `0,0` | primary | 10 |
| `DP-2` | right, `1920,0` | secondary | 2 |

The monitor layout, workspace placement, and the startup app arrangement
(whose window sizes are in pixels) all assume this. Other setups install fine,
and `install.sh` tells you what to adjust; see [Make it yours](#make-it-yours).

## Install

On an Omarchy system:

```bash
git clone https://github.com/truenito/goat ~/Projects/desktop/omarchy
cd ~/Projects/desktop/omarchy
./install.sh
```

Just want the colours and wallpapers? The theme alone is at
[truenito/omarchy-goat-theme](https://github.com/truenito/omarchy-goat-theme):
`omarchy theme install https://github.com/truenito/omarchy-goat-theme`.

Re-running it is safe. Everything is **linked** back to this repo rather than
copied, so keep the repo where you cloned it and make every change here; it
takes effect live. A file goat replaces is kept beside it as `*.goat-bak`, and
`./uninstall.sh` puts it back.

## What's inside

| Folder | What it is | Linked to |
|---|---|---|
| `theme/` | The Omarchy theme: `colors.toml` palette, wallpapers, lock-screen logo, icon set name | `~/.config/omarchy/themes/goat` |
| `icons/` | `build.py` draws the **Goat-Cream** folder icons (Yaru for everything else) | `~/.local/share/icons/Goat-Cream` |
| `daynight/` | `daynight` swaps each wallpaper for its `-night` twin at sunset and back at sunrise | run by the hooks |
| `harmony/` | `harmony` themes Zen and GTK apps (Nautilus, dialogs) from the active palette | run by the hooks |
| `hooks/` | `post-boot` starts the wallpaper daemon; `theme-set` reruns harmony and daynight | `~/.config/omarchy/hooks/*.d/goat` |
| `hypr/` | Hyprland: monitors, hotkeys, look and feel, workspaces, startup layout, and their scripts | `~/.config/hypr/` |
| `shell/` | Bar layout and widget settings, the plugin list, and the **My Notifications** plugin | restored into `~/.config/omarchy/` |

Apps Omarchy already themes from `colors.toml` follow goat automatically:
terminals, Brave and Chromium, VS Code, Obsidian, Neovim, btop, tmux, and the
Claude app.

## Changing things

| To change | Edit | Then |
|---|---|---|
| Colours or window border | `theme/colors.toml` | `omarchy theme set goat` |
| Wallpapers | add `name.jpg` + `name-night.jpg` to `theme/wallpapers/` | `omarchy theme set goat` |
| Folder icons | the constants at the top of `icons/build.py` | `./install.sh` |
| Hotkeys, glass, tiling | `hypr/*.lua` | saves reload automatically |
| Bar layout or plugins | use Omarchy as usual | `./install.sh --export` to save it here |

## Make it yours

Some of goat is tuned to gvbrl's desk; adjust these before using it:

- `hypr/monitors.lua` sets the two 1920×1080 outputs, `DP-1` left and `DP-2`
  right. Check your output names with `hyprctl monitors all`.
- `hypr/workspaces.lua` puts workspace 10 on `DP-1` and 2 on `DP-2`.
- `hypr/scripts/startup-layout.sh` opens Slack, ChatGPT, Discord, Claude and
  Zen in a saved arrangement across those two monitors at login, sized in
  pixels for 1920×1080. Remove the line in `hypr/autostart.lua` to skip it.
- `hypr/bindings.lua` maps Discord mute/deafen to the `XF86Tools` and
  `XF86Launch5` keys.

`input.lua` (keyboard layout, mouse) stays per-machine and isn't part of goat.

## Wallpapers that follow the sun

Each day the daemon looks up sunrise and sunset for your location, from your
Omarchy weather location or a guess from your IP address. Your location is
never saved. It only acts while goat is the active theme, and leaves any
wallpaper without a `-night` twin alone.
Log: `~/.local/state/omarchy/goat-daynight.log`.

## License

MIT, see `LICENSE`. `shell/plugins/gvbrl.notifications` is adapted from
Omarchy's built-in notifications plugin (MIT).
