local mainMod = "SUPER"

-- Strict UWSM wrapper for application launching
local function app(cmd)
  return "uwsm app -- " .. cmd
end

-- Import this module via homeManagerModules.default, then apply with Home Manager.
-- Available bindings:
-- - SUPER + Return -> Ghostty
-- - SUPER + F -> Firefox
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(app("ghostty")))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(app("firefox")))
