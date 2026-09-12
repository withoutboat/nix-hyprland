local mainMod = "SUPER"

-- Strict UWSM wrapper for application launching
local function app(cmd)
  return "uwsm app -- " .. cmd
end

-- ==========================================
-- AUTOSTART
-- ==========================================
hl.on("hyprland.start", function()
  hl.exec_cmd(app("waybar"))
end)

-- ==========================================
-- APPLICATION LAUNCHERS
-- ==========================================
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(app("ghostty")))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(app("firefox")))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(app("wofi --show drun")))

-- ==========================================
-- NAVIGATION & FOCUS (jk up/down, hl left/right)
-- ==========================================
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- ==========================================
-- WINDOW DRAGGING / MOVING (+ SHIFT)
-- ==========================================
-- jk: move active window up/down within workspace
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- hl: drag active window left to existing workspaces, right to newly created workspace
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ workspace = "r+1" }))

-- ==========================================
-- WORKSPACE NAVIGATION (SUPER + Tab + hl)
-- ==========================================
-- Switch between workspaces: left to existing, right to next (creates new workspace if none exists)
hl.bind(mainMod .. " + Tab + H", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + Tab + L", hl.dsp.focus({ workspace = "r+1" }))

