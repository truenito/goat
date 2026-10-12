-- goat: which workspace lives on which monitor. The apps and their tiling are
-- rebuilt at login by scripts/startup-layout.sh.

-- DP-1 (primary) -> workspace 10, DP-2 -> workspace 2. Both persist when empty.
hl.workspace_rule({ workspace = "2", monitor = "DP-2", persistent = true, default = true })
hl.workspace_rule({ workspace = "10", monitor = "DP-1", persistent = true, default = true })
