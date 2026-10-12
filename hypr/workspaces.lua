-- goat: which workspace lives on which monitor, and how it tiles. The apps
-- are arranged at login by scripts/startup-layout.sh.

-- DP-2 -> workspace 2, tiled with Omarchy's default dwindle layout.
hl.workspace_rule({ workspace = "2", monitor = "DP-2", persistent = true, default = true })

-- DP-1 (primary) -> workspace 10, using the scrolling layout: windows sit in
-- columns, centered, so a pair never stretches across the whole screen.
hl.workspace_rule({ workspace = "10", monitor = "DP-1", persistent = true, default = true, layout = "scrolling" })
