local mainMod = "SUPER"

-- Strict UWSM wrapper for application launching
local function app(cmd)
  return "uwsm app -- " .. cmd
end

-- Sort windows row-by-row (top-to-bottom) then column-by-column (left-to-right)
-- E.g. two rows of two windows will be ordered: 1, 2 (top row), 3, 4 (bottom row)
local function sort_windows(wins)
  if #wins <= 1 then return wins end

  table.sort(wins, function(a, b)
    if a.at.y ~= b.at.y then
      return a.at.y < b.at.y
    end
    return a.at.x < b.at.x
  end)

  local current_row = 1
  local row_base_y = wins[1].at.y

  for _, w in ipairs(wins) do
    local threshold = math.max(40, (w.size and w.size.y or 100) * 0.3)
    if (w.at.y - row_base_y) > threshold then
      current_row = current_row + 1
      row_base_y = w.at.y
    end
    w._row = current_row
  end

  table.sort(wins, function(a, b)
    if a._row ~= b._row then
      return a._row < b._row
    end
    return a.at.x < b.at.x
  end)

  return wins
end

local function get_workspace_windows(ws_id)
  local wins = {}
  local all_wins = hl.get_windows({ workspace = ws_id, mapped = true }) or {}
  for _, w in ipairs(all_wins) do
    if not w.hidden and not w.floating then
      table.insert(wins, w)
    end
  end
  if #wins == 0 then
    for _, w in ipairs(all_wins) do
      if not w.hidden then
        table.insert(wins, w)
      end
    end
  end
  return sort_windows(wins)
end

-- Switch between windows:
-- dir = 1 (k / right): 1 -> 2 -> 3 -> 4. On last window, switch to next workspace if one exists.
-- dir = -1 (j / left): 4 -> 3 -> 2 -> 1. On first window, switch to prev workspace if one exists.
local function switch_window(dir)
  local active_ws = hl.get_active_workspace()
  if not active_ws then return end

  local wins = get_workspace_windows(active_ws.id)
  local active_win = hl.get_active_window()
  local cur_idx = nil
  if active_win then
    for i, w in ipairs(wins) do
      if w.address == active_win.address then
        cur_idx = i
        break
      end
    end
  end

  if dir > 0 then
    if cur_idx and cur_idx < #wins then
      hl.dispatch(hl.dsp.focus({ window = wins[cur_idx + 1] }))
    elseif #wins > 0 and not cur_idx then
      hl.dispatch(hl.dsp.focus({ window = wins[1] }))
    else
      -- On the last window: switch to neighbor workspace if one exists
      local workspaces = hl.get_workspaces()
      local next_ws = nil
      for _, ws in ipairs(workspaces) do
        if ws.id > active_ws.id and not ws.special then
          if not next_ws or ws.id < next_ws.id then
            next_ws = ws
          end
        end
      end
      if next_ws then
        hl.dispatch(hl.dsp.focus({ workspace = tostring(next_ws.id) }))
        local next_wins = get_workspace_windows(next_ws.id)
        if #next_wins > 0 then
          hl.dispatch(hl.dsp.focus({ window = next_wins[1] }))
        end
      end
    end
  else
    if cur_idx and cur_idx > 1 then
      hl.dispatch(hl.dsp.focus({ window = wins[cur_idx - 1] }))
    elseif #wins > 0 and not cur_idx then
      hl.dispatch(hl.dsp.focus({ window = wins[#wins] }))
    else
      -- On the first window: switch to previous neighbor workspace if one exists
      local workspaces = hl.get_workspaces()
      local prev_ws = nil
      for _, ws in ipairs(workspaces) do
        if ws.id < active_ws.id and ws.id > 0 and not ws.special then
          if not prev_ws or ws.id > prev_ws.id then
            prev_ws = ws
          end
        end
      end
      if prev_ws then
        hl.dispatch(hl.dsp.focus({ workspace = tostring(prev_ws.id) }))
        local prev_wins = get_workspace_windows(prev_ws.id)
        if #prev_wins > 0 then
          hl.dispatch(hl.dsp.focus({ window = prev_wins[#prev_wins] }))
        end
      end
    end
  end
end

-- Switch between workspaces:
-- dir = 1 (l / right): next workspace
-- dir = -1 (h / left): previous workspace
local function switch_workspace(dir)
  local active_ws = hl.get_active_workspace()
  if not active_ws then
    hl.dispatch(hl.dsp.focus({ workspace = dir > 0 and "m+1" or "m-1" }))
    return
  end

  local workspaces = hl.get_workspaces()
  local valid = {}
  for _, ws in ipairs(workspaces) do
    if ws.id > 0 and not ws.special then
      table.insert(valid, ws)
    end
  end
  table.sort(valid, function(a, b) return a.id < b.id end)

  if dir > 0 then
    for _, ws in ipairs(valid) do
      if ws.id > active_ws.id then
        hl.dispatch(hl.dsp.focus({ workspace = tostring(ws.id) }))
        return
      end
    end
    hl.dispatch(hl.dsp.focus({ workspace = "m+1" }))
  else
    for i = #valid, 1, -1 do
      local ws = valid[i]
      if ws.id < active_ws.id then
        hl.dispatch(hl.dsp.focus({ workspace = tostring(ws.id) }))
        return
      end
    end
    hl.dispatch(hl.dsp.focus({ workspace = "m-1" }))
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
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(app("firefox")))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(app("wofi --show drun")))

-- ==========================================
-- NAVIGATION & WINDOW SWITCHING
-- ==========================================
-- Switch between windows (12344321, on last window switch to neighbor workspace)
hl.bind(mainMod .. " + K", function() switch_window(1) end)
hl.bind(mainMod .. " + J", function() switch_window(-1) end)

-- Switch between workspaces (lead hl)
hl.bind(mainMod .. " + L", function() switch_workspace(1) end)
hl.bind(mainMod .. " + H", function() switch_workspace(-1) end)

