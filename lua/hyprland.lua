local mainMod = "SUPER"

-- Strict UWSM wrapper for application launching
local function app(cmd)
  return "uwsm app -- " .. cmd
end

-- Helper: Focus nearest matching window or launch application.
-- If the active window matches, launches a new instance.
local function is_app(win, class_pattern)
  if not win then return false end
  local c = (win.class or ""):lower()
  local ic = (win.initial_class or ""):lower()
  return c:find(class_pattern) ~= nil or ic:find(class_pattern) ~= nil
end

local function focus_or_launch(cmd, class_pattern)
  return function()
    local active = hl.get_active_window()
    if active and is_app(active, class_pattern) then
      hl.exec_cmd(app(cmd))
      return
    end

    local all_wins = hl.get_windows() or {}
    local matching_wins = {}
    for _, w in ipairs(all_wins) do
      if is_app(w, class_pattern) and not w.hidden then
        table.insert(matching_wins, w)
      end
    end

    if #matching_wins == 0 then
      hl.exec_cmd(app(cmd))
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
      hl.exec_cmd(app(cmd))
    end
  end
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
hl.bind(mainMod .. " + F", focus_or_launch("firefox", "firefox"))
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

