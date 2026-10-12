# goat

*A quiet mountain look and feel for [Omarchy](https://omarchy.org/), by truenito.*

Above the tree line the fog rolls in slowly. The pines go soft and grey, and
somewhere on the ridge a goat stands perfectly still, sure-footed and in no
hurry at all. goat is that moment kept on your desktop: calm, unhurried, a
little old-fashioned in the best way.

goat is the whole desktop, not just colours:

- **Dark walnut** backgrounds and **warm cream** text, with light-brown highlights
- **Deep jade** window borders and focus rings, like polished stone on walnut
- **Retro fog wallpapers** that follow the sun: soft mist by day, silver dusk haze by night
- **Cream folder icons**, and Zen and GTK apps styled to match
- **Frosted glass**: unfocused windows soften slightly over a blur
- **Saved app layouts** across two monitors, rebuilt with one key

Built for **two 1920×1080 monitors**: `DP-1` (main, left) and `DP-2` (right).

## Install

```bash
git clone https://github.com/truenito/goat ~/projects/desktop/omarchy
cd ~/projects/desktop/omarchy
./install.sh
```

Everything is linked back to the repo, so edit files there. `./uninstall.sh`
undoes it. Want only the colours and wallpapers? Use
[truenito/omarchy-goat-theme](https://github.com/truenito/omarchy-goat-theme).

## Hotkeys

goat keeps every Omarchy shortcut and adds:

| Keys | What it does |
|---|---|
| Tap `Super` | Opens the Omarchy menu |
| `Super` + `W` | Closes the window; quits Steam fully instead of hiding it |
| `Super` + `Ctrl` + `N` | Toggles a gentle 5500K nightlight |
| `End` | Rebuilds the work layout |
| `Super` + `End` | Rebuilds the off-work layout (quits Slack) |
| `XF86Tools` / `XF86Launch5` | Deafen / mute in Discord, even when it isn't focused |

## Layouts

Applied at login (work on weekdays 6 AM–7 PM, off-work otherwise) and by the
keys above. Running apps are only moved and resized, never restarted.

**Work** (`End`)

```
DP-1 · workspace 10 · main       DP-2 · workspace 2
┌───────────┬───────────────┐    ┌─────────────────┬──────────┬───┐
│           │               │    │                 │          │ D │
│   Claude  │               │    │                 │          │ i │
│           │               │    │                 │ ChatGPT  │ s │
├───────────┤      Zen      │    │      Slack      │          │ c │
│   Claude  │               │    │                 │          │ o │
│    Code   │               │    │                 ├──────────┤ r │
│           │               │    │                 │ Terminal │ d │
└───────────┴───────────────┘    └─────────────────┴──────────┴───┘
```

**Off-work** (`Super` + `End`)

```
DP-1 · workspace 10 · main       DP-2 · workspace 2
┌───────────┬───────────────┐    ┌──────────────────────┬────────┐
│           │               │    │                      │        │
│           │               │    │                      │        │
│   Claude  │               │    │                      │        │
│           │      Zen      │    │       Discord        │ChatGPT │
│           │               │    │                      │        │
├───────────┤               │    │                      │        │
│  Terminal │               │    │                      │        │
└───────────┴───────────────┘    └──────────────────────┴────────┘
```

## Make it yours

Different apps, monitors, hours or keys? The
[wiki](https://github.com/truenito/goat/wiki) has short guides for
customizing, the startup layouts, workspaces and hotkeys, the day and night
wallpapers, and how goat installs.

## License

MIT, see `LICENSE`. The notifications plugin is adapted from Omarchy's
built-in one (MIT).
