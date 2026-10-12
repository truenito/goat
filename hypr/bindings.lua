-- goat: keybindings on top of Omarchy's defaults.
-- List every binding with: omarchy menu keybindings --print
-- To replace a default, hl.unbind() it before binding the key again.

local scripts = os.getenv("HOME") .. "/.config/hypr/scripts/"

-- Tap SUPER alone (on release) to open the Omarchy menu, same as SUPER+SPACE.
o.bind("SUPER + SUPER_L", "Omarchy menu", "omarchy-menu toggle", { release = true })

-- Close window, except Steam windows quit Steam instead of hiding it.
hl.unbind("SUPER + W")
o.bind("SUPER + W", "Close window", scripts .. "close-window.sh")

-- Milder nightlight (5500K instead of the stock 4000K). Tune ON_TEMP in the script.
hl.unbind("SUPER + CTRL + N")
o.bind("SUPER + CTRL + N", "Toggle nightlight", scripts .. "nightlight-toggle.sh")

-- Snap windows back into the startup layout. Running apps are only moved and
-- resized; an app is launched only if it has no window open.
o.bind("End", "Restore work layout", scripts .. "startup-layout.sh work")
o.bind("SUPER + End", "Off-work layout", scripts .. "startup-layout.sh off")

-- Discord mute/deafen from two extra keys. The shortcut goes straight to the
-- Discord window, so it works even when Discord isn't focused; match these to
-- Discord Settings > Keybinds. Down and up are sent separately (like Omarchy's
-- clipboard bindings) so no key gets stuck.
local function send_to_discord(mods, key)
  return function()
    local window = "class:^(discord)$"
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down", window = window }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up", window = window }))
    end, { timeout = 50, type = "oneshot" })
  end
end

o.bind("XF86Tools", "Discord deafen", send_to_discord("CTRL SHIFT", "D"))
o.bind("XF86Launch5", "Discord mute", send_to_discord("CTRL SHIFT", "M"))
