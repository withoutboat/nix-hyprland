local mainMod = "SUPER"

-- Strict UWSM wrapper for application launching
local function app(cmd, app_name)
  if app_name then
    return string.format("uwsm app -a %s -- %s", app_name, cmd)
  end
  return "uwsm app -- " .. cmd
end

-- Helper to generate a shell command with binary fallbacks (e.g. telegram-desktop vs Telegram)
local function cmd_fallback(candidates)
  if type(candidates) == "string" then
    return candidates
  end
  local parts = {}
  for _, c in ipairs(candidates) do
    local bin = c:match("^%S+")
    table.insert(parts, string.format("command -v %s >/dev/null 2>&1 && exec %s", bin, c))
  end
  return string.format("sh -c '%s || exec %s'", table.concat(parts, " || "), candidates[1])
end

-- ==========================================
-- CURSOR CONFIGURATION
-- ==========================================
hl.config({
  cursor = {
    inactive_timeout = 2,
    enable_hyprcursor = true,
    sync_gsettings_theme = true,
  },
})

hl.env("XCURSOR_THEME", "Breeze_Hacked")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Breeze_Hacked")
hl.env("HYPRCURSOR_SIZE", "24")

-- ==========================================
-- DESKTOP & WAYLAND INTEGRATION
-- ==========================================
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Native Wayland for Electron / Chromium apps (Slack, Copilot, etc.)
hl.env("NIXOS_OZONE_WL", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Toolkit Wayland backends
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- Helper: Focus nearest matching window or launch application.
-- If the active window matches, launches a new instance.
local function is_app(win, class_patterns)
  if not win then return false end
  local c = (win.class or ""):lower()
  local ic = (win.initial_class or ""):lower()

  if type(class_patterns) == "string" then
    class_patterns = { class_patterns }
  end

  for _, pat in ipairs(class_patterns) do
    local p = pat:lower()
    if c:find(p, 1, true) or ic:find(p, 1, true) then
      return true
    end
  end
  return false
end

local function focus_or_launch(cmd, class_patterns, app_name)
  return function()
    local active = hl.get_active_window()
    if active and is_app(active, class_patterns) then
      hl.exec_cmd(app(cmd, app_name))
      return
    end

    local all_wins = hl.get_windows() or {}
    local matching_wins = {}
    for _, w in ipairs(all_wins) do
      if is_app(w, class_patterns) and not w.hidden then
        table.insert(matching_wins, w)
      end
    end

    if #matching_wins == 0 then
      hl.exec_cmd(app(cmd, app_name))
      return
    end

    local active_ws = hl.get_active_workspace()
    local active_ws_id = (active_ws and type(active_ws.id) == "number") and active_ws.id or 0

    local ref_x, ref_y = 0, 0
    if active and active.at and active.size then
      ref_x = active.at.x + (active.size.x or 0) / 2
      ref_y = active.at.y + (active.size.y or 0) / 2
    else
      local cur_pos = hl.get_cursor_pos()
      if cur_pos then
        ref_x = cur_pos.x or 0
        ref_y = cur_pos.y or 0
      end
    end

    local best_win = nil
    local min_dist = math.huge

    for _, w in ipairs(matching_wins) do
      local w_ws = w.workspace
      local w_ws_id = (w_ws and type(w_ws.id) == "number") and w_ws.id or 0
      local is_same_ws = (w_ws and active_ws and w_ws == active_ws) or (w_ws_id ~= 0 and w_ws_id == active_ws_id)
      local dist

      if is_same_ws then
        local wx = (w.at and w.at.x or 0) + (w.size and w.size.x or 0) / 2
        local wy = (w.at and w.at.y or 0) + (w.size and w.size.y or 0) / 2
        local dx = wx - ref_x
        local dy = wy - ref_y
        dist = math.sqrt(dx * dx + dy * dy)
      else
        local ws_diff = math.abs(w_ws_id - active_ws_id)
        local hist = w.focus_history_id or 999
        dist = 1e6 + ws_diff * 1e4 + hist
      end

      if dist < min_dist then
        min_dist = dist
        best_win = w
      end
    end

    if best_win then
      hl.dispatch(hl.dsp.focus({ window = best_win }))
    else
      hl.exec_cmd(app(cmd, app_name))
    end
  end
end

-- ==========================================
-- AUTOSTART
-- ==========================================
hl.on("hyprland.start", function()
  -- Finalize UWSM session & export variables to systemd and D-Bus activation environments.
  -- This eliminates app startup delays (resolving 10-25s UWSM and xdg-desktop-portal timeouts).
  hl.exec_cmd("uwsm finalize")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE NIXOS_OZONE_WL ELECTRON_OZONE_PLATFORM_HINT")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE NIXOS_OZONE_WL ELECTRON_OZONE_PLATFORM_HINT")
  hl.exec_cmd(app("waybar"))
end)

-- ==========================================
-- APPLICATION LAUNCHERS
-- ==========================================
hl.bind(mainMod .. " + Return", focus_or_launch("ghostty", "ghostty", "ghostty"))
hl.bind(mainMod .. " + F", focus_or_launch("firefox", "firefox", "firefox"))
hl.bind(mainMod .. " + S", focus_or_launch(cmd_fallback({ "slack", "Slack", "flatpak run com.slack.Slack" }), "slack", "slack"))
hl.bind(mainMod .. " + T", focus_or_launch(cmd_fallback({ "telegram-desktop", "Telegram", "flatpak run org.telegram.desktop" }), { "telegram", "org.telegram.desktop" }, "telegram"))
hl.bind(mainMod .. " + Z", focus_or_launch(cmd_fallback({ "zoom", "zoom-us", "flatpak run us.zoom.Zoom" }), "zoom", "zoom"))
hl.bind(mainMod .. " + G", focus_or_launch(cmd_fallback({ "github-copilot", "github-copilot-desktop", "copilot", "flatpak run com.github.copilot" }), { "github-copilot", "github", "copilot" }, "github-copilot"))
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

-- ==========================================
-- WINDOW CLOSING (SUPER + X close active, SUPER + Escape close all)
-- ==========================================
-- Close current active window / application
hl.bind(mainMod .. " + X", hl.dsp.window.close())

-- Close all windows / applications
local function close_all()
  local all_wins = hl.get_windows() or {}
  for _, w in ipairs(all_wins) do
    hl.dispatch(hl.dsp.window.close({ window = w }))
  end
end

hl.bind(mainMod .. " + Escape", close_all)
