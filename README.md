# Goat

*A quiet mountain look and feel for [Omarchy](https://omarchy.org/), by truenito.*

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

## Hotkeys

Goat keeps every Omarchy shortcut and adds these (`hypr/bindings.lua`):

| Keys | What it does |
|---|---|
| Tap `Super` alone | Opens the Omarchy menu, same as `Super` + `Space` |
| `Super` + `W` | Closes the focused window. A Steam window quits Steam completely instead of hiding it in the background |
| `Super` + `Ctrl` + `N` | Toggles a gentle nightlight at 5500K (Omarchy's stock one is a stronger 4000K) |
| `End` | Rebuilds the **work layout** across both monitors (see [Layouts](#layouts)) |
| `Super` + `End` | Rebuilds the **off-work layout**: quits Slack, gives Discord most of the screen, and puts a terminal under Claude |
| `XF86Tools` | Deafens in Discord, even when Discord isn't focused |
| `XF86Launch5` | Mutes in Discord, even when Discord isn't focused |

### Layouts

Goat arranges your apps into a saved layout at login, and `End` or
`Super` + `End` put everything back whenever windows have drifted. Both are
handled by `hypr/scripts/startup-layout.sh`.

**Work layout** (`End`, and at login on weekdays from 6 AM to 7 PM):

```
DP-2 · workspace 2                       DP-1 · workspace 10
┌─────────┬───────────┬─────────┐        ┌──────────────┬──────────┐
│         │  ChatGPT  │         │        │    Claude    │          │
│  Slack  ├───────────┤ Discord │        ├──────────────┤   Zen    │
│         │ Terminal  │         │        │  Claude Code │          │
└─────────┴───────────┴─────────┘        └──────────────┴──────────┘
```

**Off-work layout** (`Super` + `End`, and at login on evenings and weekends):

```
DP-2 · workspace 2                       DP-1 · workspace 10
┌──────────────────────┬────────┐        ┌──────────┬──────────────┐
│                      │        │        │  Claude  │              │
│       Discord        │ChatGPT │        │          │     Zen      │
│                      │        │        ├──────────┤              │
│                      │        │        │ Terminal │              │
└──────────────────────┴────────┘        └──────────┴──────────────┘
```

Off-work quits Slack and gives Discord most of the screen. On the left,
Claude gets most of its column with a small terminal underneath, and Claude
Code stays out of sight if it's running.

Workspace 10 uses Hyprland's scrolling layout: windows sit in centered
columns instead of stretching across the whole screen. Workspace 2 tiles
normally.

Rebuilding never closes or restarts what's already running. Open windows are
moved back into place and resized; an app is launched only if it isn't open,
so the first `End` of the day can take a moment while apps start. Fullscreen
or floating windows in the layout are returned to normal tiling first. The
focus ends on workspace 10.

To use different apps, order or hours, see
[Guide: your own apps, order and workspace keys](#guide-your-own-apps-order-and-workspace-keys).

### Other keys

The Discord keys are the two extra keys on truenito's keyboard. They send
`Ctrl` + `Shift` + `D` and `Ctrl` + `Shift` + `M` to Discord, so set those in
Discord Settings → Keybinds.

Omarchy's own shortcuts still apply, for example `Super` + `1`…`0` to switch
workspace and `Super` + `Shift` + `1`…`0` to move a window there. See them all
with `omarchy menu keybindings --print`.

## Changing things

| To change | Edit | Then |
|---|---|---|
| Colours or window border | `theme/colors.toml` | `omarchy theme set goat` |
| Wallpapers | add `name.jpg` + `name-night.jpg` to `theme/wallpapers/` | `omarchy theme set goat` |
| Folder icons | the constants at the top of `icons/build.py` | `./install.sh` |
| Hotkeys, glass, tiling | `hypr/*.lua` | saves reload automatically |
| Bar layout or plugins | use Omarchy as usual | `./install.sh --export` to save it here |

## Make it yours

Some of goat is tuned to truenito's desk; adjust these before using it:

- `hypr/monitors.lua` sets the two 1920×1080 outputs, `DP-1` left and `DP-2`
  right. Check your output names with `hyprctl monitors all`.
- `hypr/workspaces.lua` puts workspace 10 on `DP-1` and 2 on `DP-2`.
- `hypr/scripts/startup-layout.sh` opens Slack, ChatGPT, Discord, Claude and
  Zen in a saved arrangement across those two monitors at login, sized in
  pixels for 1920×1080. Remove the line in `hypr/autostart.lua` to skip it.
- `hypr/bindings.lua` maps Discord mute/deafen to the `XF86Tools` and
  `XF86Launch5` keys.

`input.lua` (keyboard layout, mouse) stays per-machine and isn't part of goat.

## Guide: your own apps, order and workspace keys

### How the startup layout works

`hypr/scripts/startup-layout.sh` builds the layout one window at a time:

```bash
dispatch 'hl.dsp.focus({ workspace = "2" })'   # go to workspace 2
slack=$(open slack slack)                       # first app fills the workspace
focus "$slack"; chatgpt=$(open chatgpt chatgpt) # next app splits Slack
resize "$slack" 1074 "$(height_of "$slack")"   # then set sizes
```

- **`open <window-class> <command>`** brings back that app's window, or runs
  the command if it isn't open.
- **Order is the split.** Each new window splits the window focused just
  before it, landing to its right (or below it, if that window is taller than
  wide). So `focus "$slack"` before opening ChatGPT puts ChatGPT next to Slack.
- **On workspace 10** (scrolling), each new window opens as a column to the
  right of the focused one. `stack <window>` tucks it under the column to its
  left, `column_width <window> 0.32` sets a column's width as a fraction of
  the screen, and `set_height <window> 873` sets a height in pixels.
- **`resize <window> <width> <height>`** sets a size in pixels on workspace 2. Resize the left
  or top window of a pair; resizing the right or bottom one moves the wrong edge.
- **`LAYOUT_CLASSES`** near the top lists every app the script manages. It
  parks them out of sight before rebuilding, so the layout comes out the same
  every time.
- The **work** and **off-work** layouts are the two branches of the
  `if [[ $mode == off ]]` block. `auto` (used at login) picks off-work on
  weekends and on weekdays before 6 AM or from 7 PM; change those hours on the
  `if (( dow >= 6 || hour < 6 || hour >= 19 ))` line.

### Swap an app

1. Open the app and find its window class:

   ```bash
   hyprctl activewindow -j | jq -r .class
   ```

2. In `startup-layout.sh`, replace the app's `open` line and add the class to
   `LAYOUT_CLASSES`. For example, Spotify instead of ChatGPT:

   ```bash
   LAYOUT_CLASSES=(slack Spotify discord foot com.anthropic.Claude zen org.omarchy.agent)
   ...
   focus "$slack"; spotify=$(open Spotify spotify)
   ```

   Then rename any later `$chatgpt` references to `$spotify`.

3. Press `End` to rebuild the layout and check it.

To add an app, add another `focus …; name=$(open class command)` line wherever
it should split in. To drop one, delete its line. To skip the startup layout
completely, remove the `exec_on_start` line from `hypr/autostart.lua`.

### Change where workspaces live

`hypr/workspaces.lua` pins each workspace to a monitor:

```lua
hl.workspace_rule({ workspace = "2", monitor = "DP-2", persistent = true, default = true })
```

Change `workspace` or `monitor` to taste. If you renumber a workspace, also
change the matching `hl.dsp.focus({ workspace = "…" })` line in
`startup-layout.sh`.

### Change workspace hotkeys

Omarchy binds `Super` + `1`…`0` to workspaces 1–10. Add your own in
`hypr/bindings.lua`; for example, jump straight to the two layout workspaces:

```lua
o.bind("SUPER + ALT + C", "Chat workspace", hl.dsp.focus({ workspace = "2" }))
o.bind("SUPER + ALT + W", "Work workspace", hl.dsp.focus({ workspace = "10" }))
```

To move an existing key, unbind it first, then bind it again. Number keys are
written as key codes: `code:10` is `1` through `code:19` for `0`.

```lua
hl.unbind("SUPER + code:19")
o.bind("SUPER + code:19", "Switch to workspace 2", hl.dsp.focus({ workspace = "2" }))
```

Hyprland reloads when you save. Check for mistakes with `hyprctl configerrors`.

## Wallpapers that follow the sun

Each day the daemon looks up sunrise and sunset for your location, from your
Omarchy weather location or a guess from your IP address. Your location is
never saved. It only acts while goat is the active theme, and leaves any
wallpaper without a `-night` twin alone.
Log: `~/.local/state/omarchy/goat-daynight.log`.

## License

MIT, see `LICENSE`. `shell/plugins/truenito.notifications` is adapted from
Omarchy's built-in notifications plugin (MIT).
