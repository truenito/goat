-- goat: look and feel on top of Omarchy's defaults.
-- Options: https://wiki.hypr.land/Configuring/Basics/Variables/
-- Border colours come from the theme (theme/colors.toml), not from here.

-- Frosted glass: unfocused windows are slightly see-through over a soft blur,
-- and the bar is blurred too.
hl.config({
  decoration = {
    active_opacity = 1.00,
    inactive_opacity = 0.90,
    blur = {
      enabled = true,
      size = 5,
      passes = 5,
      ignore_opacity = true,
      new_optimizations = true,
    },
  },
})
hl.layer_rule({ match = { namespace = "omarchy-bar" }, blur = true, blur_popups = true, ignore_alpha = 0.0 })
