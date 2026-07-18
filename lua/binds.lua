-- Strict UWSM wrapper for application launching
local function app(cmd)
  return "uwsm app -- " .. cmd
end

-- ==========================================
-- WINDOW RESIZING (Arrows & HJKL)
-- ==========================================
hl.bind(mainMod .. " + SHIFT", "right", "resizeactive 30 0", { repeating = true })
hl.bind(mainMod .. " + SHIFT", "left", "resizeactive -30 0", { repeating = true })
hl.bind(mainMod .. " + SHIFT", "up", "resizeactive 0 -30", { repeating = true })
hl.bind(mainMod .. " + SHIFT", "down", "resizeactive 0 30", { repeating = true })

hl.bind(mainMod .. " + SHIFT", "l", "resizeactive 30 0", { repeating = true })
hl.bind(mainMod .. " + SHIFT", "h", "resizeactive -30 0", { repeating = true })
hl.bind(mainMod .. " + SHIFT", "k", "resizeactive 0 -30", { repeating = true })
hl.bind(mainMod .. " + SHIFT", "j", "resizeactive 0 30", { repeating = true })

-- ==========================================
-- MOUSE BINDS (Dragging)
-- ==========================================
hl.bind(mainMod, "mouse:272", "movewindow", { mouse = true })
hl.bind(mainMod, "mouse:273", "resizewindow", { mouse = true })

-- ==========================================
-- HARDWARE & MEDIA CONTROL
-- ==========================================
hl.bind("", "XF86MonBrightnessDown", "exec " .. app("brightnessctl set 2%-"), { repeating = true })
hl.bind("", "XF86MonBrightnessUp", "exec " .. app("brightnessctl set +2%"), { repeating = true })
hl.bind("", "XF86AudioLowerVolume", "exec " .. app("pamixer -d 2"), { repeating = true })
hl.bind("", "XF86AudioRaiseVolume", "exec " .. app("pamixer -i 2"), { repeating = true })
hl.bind("", "XF86AudioMicMute", "exec " .. app("pamixer --default-source -t"))
hl.bind("", "XF86AudioMute", "exec " .. app("pamixer -t"))

hl.bind("", "XF86AudioPlay", "exec " .. app("playerctl play-pause"))
hl.bind("", "XF86AudioPause", "exec " .. app("playerctl play-pause"))
hl.bind("", "xf86AudioNext", "exec " .. app("playerctl next"))
hl.bind("", "xf86AudioPrev", "exec " .. app("playerctl previous"))
hl.bind("", "xf86Sleep", "exec systemctl suspend")

-- ==========================================
-- UTILITIES & MENUS
-- ==========================================
hl.bind(mainMod, "question", "exec " .. app(keybinds_yad))
hl.bind(mainMod, "slash", "exec " .. app(keybinds_yad))
hl.bind(mainMod .. " + CTRL", "K", "exec " .. app(keybinds_yad))

hl.bind(mainMod, "F8", "exec kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || " .. app(autoclicker .. " --cps 40"))
hl.bind(mainMod, "F9", "exec " .. app("hyprsunset --temperature 2500"))
hl.bind(mainMod, "F10", "exec pkill hyprsunset")

-- ==========================================
-- WINDOW / SESSION ACTIONS
-- ==========================================
hl.bind(mainMod, "Q", "killactive")
hl.bind("ALT", "F4", "killactive")
hl.bind(mainMod, "delete", "exit")
hl.bind(mainMod, "W", "togglefloating")
hl.bind(mainMod .. " + SHIFT", "G", "togglegroup")
hl.bind("ALT", "return", "fullscreen")
hl.bind(mainMod .. " + ALT", "L", "exec " .. app("hyprlock"))
hl.bind(mainMod, "backspace", "exec " .. app("pkill -x wlogout || wlogout -b 4"))

-- Toggle status bar safely
hl.bind("CONTROL", "ESCAPE", 'exec pkill "waybar|hyprpanel|wayle" || ' .. app(bar))

-- Display Zoom
hl.bind(mainMod .. " + CTRL", "mouse_down", "exec " .. app(zoom .. " in"))
hl.bind(mainMod .. " + CTRL", "mouse_up", "exec " .. app(zoom .. " out"))

-- ==========================================
-- APPLICATIONS (Exclusively via UWSM)
-- ==========================================
hl.bind(mainMod, "Return", "exec " .. app(term))
hl.bind(mainMod, "T", "exec " .. app(term))
hl.bind(mainMod, "E", "exec " .. app(fileManagerScript .. " " .. fileManager))
hl.bind(mainMod, "C", "exec " .. app(editor))
hl.bind(mainMod, "F", "exec " .. app(browser))
hl.bind(mainMod .. " + SHIFT", "S", "exec " .. app("spotify"))
hl.bind(mainMod .. " + SHIFT", "Y", "exec " .. app("youtube-music"))
hl.bind("CONTROL + ALT", "DELETE", "exec " .. app(term .. " -e btop"))
hl.bind("CONTROL + ALT", "M", "exec " .. app(term .. ' --class "microfetch" --hold -e microfetch'))
hl.bind(mainMod .. " + CTRL", "C", "exec " .. app("hyprpicker --autocopy --format=hex"))

-- Desktop Shell Launchers
hl.bind(mainMod, "A", "exec " .. app(launcher .. " drun"))
hl.bind(mainMod, "SPACE", "exec " .. app(launcher .. " drun"))
hl.bind(mainMod .. " + SHIFT", "W", "exec " .. app(launcher .. " wallpaper"))
hl.bind(mainMod, "Z", "exec " .. app(launcher .. " emoji"))
hl.bind(mainMod .. " + SHIFT", "T", "exec " .. app(launcher .. " tmux"))
hl.bind(mainMod, "G", "exec " .. app(launcher .. " games"))
hl.bind(mainMod .. " + ALT", "K", "exec " .. app(keyboardswitch))
hl.bind(mainMod, "V", "exec " .. app(clipmanager))
hl.bind(mainMod, "M", "exec " .. app(rofimusic))

-- Notifications & System Toggles
hl.bind(mainMod .. " + SHIFT", "N", "exec " .. app("swaync-client -t -sw"))
hl.bind(mainMod .. " + SHIFT", "Q", "exec " .. app("swaync-client -t -sw"))
hl.bind(mainMod .. " + ALT", "G", "exec " .. app(gamemode))

-- Screenshot & Screen Capture
hl.bind(mainMod .. " + SHIFT", "R", "exec " .. app(screen_record .. " a"))
hl.bind(mainMod .. " + CTRL", "R", "exec " .. app(screen_record .. " m"))
hl.bind(mainMod, "P", "exec " .. app(screenshot .. " s"))
hl.bind(mainMod .. " + CTRL", "P", "exec " .. app(screenshot .. " sf"))
hl.bind("", "print", "exec " .. app(screenshot .. " m"))
hl.bind(mainMod .. " + ALT", "P", "exec " .. app(screenshot .. " p"))

-- ==========================================
-- NAVIGATION & WORKSPACES
-- ==========================================
-- Cycling focus (Merged duplicate Tab calls into one function call to prevent crash)
hl.bind(mainMod, "Tab", "cyclenext")

-- Focus navigation (Arrows & HJKL)
hl.bind(mainMod, "left", "movefocus l")
hl.bind(mainMod, "right", "movefocus r")
hl.bind(mainMod, "up", "movefocus u")
hl.bind(mainMod, "down", "movefocus d")
hl.bind("ALT", "Tab", "movefocus d")

hl.bind(mainMod, "h", "movefocus l")
hl.bind(mainMod, "l", "movefocus r")
hl.bind(mainMod, "k", "movefocus u")
hl.bind(mainMod, "j", "movefocus d")

-- Workspace relative switching
hl.bind(mainMod .. " + CTRL", "right", "workspace r+1")
hl.bind(mainMod .. " + CTRL", "left", "workspace r-1")
hl.bind(mainMod .. " + CTRL", "down", "workspace empty")

-- Dwindle/Master layout column controls
hl.bind(mainMod, "period", "layoutmsg move +col")
hl.bind(mainMod, "comma", "layoutmsg move -col")

-- Mouse button workspace navigation (Side buttons 275/276)
hl.bind(mainMod, "mouse:276", "workspace 5")
hl.bind(mainMod, "mouse:275", "workspace 6")
hl.bind(mainMod .. " + ALT", "mouse:275", "workspace 7")
hl.bind(mainMod .. " + SHIFT", "mouse:276", "movetoworkspace 5")
hl.bind(mainMod .. " + SHIFT", "mouse:275", "movetoworkspace 6")
hl.bind(mainMod .. " + SHIFT + ALT", "mouse:275", "movetoworkspace 7")
hl.bind(mainMod .. " + CTRL", "mouse:276", "movetoworkspacesilent 5")
hl.bind(mainMod .. " + CTRL", "mouse:275", "movetoworkspacesilent 6")
hl.bind(mainMod .. " + CTRL + ALT", "mouse:275", "movetoworkspacesilent 7")

-- Mouse wheel workspace scrolling
hl.bind(mainMod, "mouse_down", "workspace e+1")
hl.bind(mainMod, "mouse_up", "workspace e-1")

-- Move window to relative workspace
hl.bind(mainMod .. " + CTRL + ALT", "right", "movetoworkspace r+1")
hl.bind(mainMod .. " + CTRL + ALT", "left", "movetoworkspace r-1")

-- Move active window around tiling grid (Arrows & HJKL)
hl.bind(mainMod .. " + SHIFT + CTRL", "left", "movewindow l")
hl.bind(mainMod .. " + SHIFT + CTRL", "right", "movewindow r")
hl.bind(mainMod .. " + SHIFT + CTRL", "up", "movewindow u")
hl.bind(mainMod .. " + SHIFT + CTRL", "down", "movewindow d")

hl.bind(mainMod .. " + SHIFT + CTRL", "H", "movewindow l")
hl.bind(mainMod .. " + SHIFT + CTRL", "L", "movewindow r")
hl.bind(mainMod .. " + SHIFT + CTRL", "K", "movewindow u")
hl.bind(mainMod .. " + SHIFT + CTRL", "J", "movewindow d")

-- Special workspace (Scratchpad) management
hl.bind(mainMod .. " + CTRL", "s", "movetoworkspacesilent special")
hl.bind(mainMod .. " + ALT", "s", "movetoworkspacesilent special")
hl.bind(mainMod, "s", "togglespecialworkspace special")

-- Dynamic Workspaces 1-10 generation
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod, tostring(key), "workspace " .. i)
  hl.bind(mainMod .. " + SHIFT", tostring(key), "movetoworkspace " .. i)
  hl.bind(mainMod .. " + CTRL", tostring(key), "movetoworkspacesilent " .. i)
end

-- Inline NixOS system rebuild trigger via standard terminal
hl.bind(mainMod, "U", "exec " .. app(term .. " -e rebuild"))
