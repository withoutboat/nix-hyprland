local mainMod = "SUPER"

-- Import this module via homeManagerModules.default, then apply with Home Manager.
-- Available bindings:
-- - SUPER + Return -> Ghostty
-- - SUPER + F -> Firefox
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
