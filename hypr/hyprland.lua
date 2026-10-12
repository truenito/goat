-- goat: Hyprland entry point. Omarchy's defaults load first, then goat's
-- overrides. See https://wiki.hypr.land/Configuring/Start/

dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")
require("default.hypr.omarchy")

-- input.lua is per-machine and not part of goat.
require("hypr.monitors")
require("hypr.workspaces")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

require("default.hypr.toggles")

-- Tile Steam's main window like a normal app; its popups (login, friends,
-- dialogs) stay floating.
o.window({ class = "steam", title = "Steam" }, { tile = true })
