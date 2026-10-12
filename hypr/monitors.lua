-- goat: built for two 1920x1080 monitors side by side.
--
--   DP-1  primary, left   workspace 10   (0, 0)
--   DP-2  second, right   workspace 2    (1920, 0)
--
-- Each runs at its preferred (native) refresh rate. List yours with:
--   hyprctl monitors all
-- On a different setup, change the output names and positions here, and the
-- workspace rules in workspaces.lua.

hl.env("GDK_SCALE", "1")

hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "preferred", position = "1920x0", scale = 1 })

-- Anything else that gets plugged in lands to the right at its preferred mode.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
