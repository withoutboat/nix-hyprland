-- ==========================================
-- SPECIFICATION & DEFAULT VARIABLES
-- ==========================================
-- These variables are typically injected by NixOS/Home Manager.
-- We set safe fallbacks here in case they are evaluated standalone.

global.kbdLayout = global.kbdLayout or "us"
global.kbdVariant = global.kbdVariant or ""
global.capslockAsESC = global.capslockAsESC or false

-- Helper function to wrap commands with UWSM cgroups execution
local function app(cmd)
  return "uwsm app -- " .. cmd
end

-- ==========================================
-- ENVIRONMENT & ASSETS
-- ==========================================
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")

-- ==========================================
-- MINIMAL AUTOSTART (UWSM Compliant)
-- ==========================================
hl.on("hyprland.start", function()
  hl.exec_cmd(app("nm-applet --indicator"))
  hl.exec_cmd(app("hyprpolkitagent"))

  -- Clipboard Management
  hl.exec_cmd(app("wl-paste --type text --watch cliphist store"))
  hl.exec_cmd(app("wl-paste --type image --watch cliphist store"))
end)

-- ==========================================
-- CORE ENGINE CONFIGURATION
-- ==========================================
hl.config({
  input = (function()
    local t = {
      kb_layout = kbdLayout .. ",ru",
      kb_variant = kbdVariant .. ",",
      repeat_delay = 275,
      repeat_rate = 35,
      numlock_by_default = true,
      follow_mouse = 1,
      sensitivity = 0,
      force_no_accel = true,
    }

    if capslockAsESC then
      t.kb_options = "caps:swapescape"
    end

    return t
  end)(),

  general = {
    gaps_in = 4,
    gaps_out = 9,
    border_size = 2,
    col = {
      active_border = { colors = { "rgba(ca9ee6ff)", "rgba(f2d5cfff)" }, angle = 45 },
      inactive_border = { colors = { "rgba(b4befecc)", "rgba(6c7086cc)" }, angle = 45 },
    },
    resize_on_border = true,
    layout = "dwindle",
  },

  decoration = {
    shadow = { enabled = false },
    rounding = 10,
    dim_special = 0.3,
    blur = {
      enabled = true,
      special = true,
      size = 6,
      passes = 2,
      new_optimizations = true,
      ignore_opacity = true,
    },
  },

  misc = {
    disable_hyprland_logo = true,
    mouse_move_focuses_monitor = true,
    swallow_regex = "^(ghostty)$",
    enable_swallow = true,
    vrr = 2,
  },

  dwindle = {
    preserve_split = true,
  },
})
