-- Strict UWSM wrapper for application launching
local function app(cmd)
  return "uwsm app -- " .. cmd
end

-- Resize windows (arrow keys)
hl.bind(mainMod .. " + SHIFT + right", hl.dispatch("resizeactive", "30 0"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + left", hl.dispatch("resizeactive", "-30 0"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dispatch("resizeactive", "0 -30"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dispatch("resizeactive", "0 30"), { repeating = true })

-- Resize windows (HJKL keys)
hl.bind(mainMod .. " + SHIFT + l", hl.dispatch("resizeactive", "30 0"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + h", hl.dispatch("resizeactive", "-30 0"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + k", hl.dispatch("resizeactive", "0 -30"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + j", hl.dispatch("resizeactive", "0 30"), { repeating = true })

-- Move/Resize windows with mouse dragging
hl.bind(mainMod .. " + mouse:272", hl.dispatch("movewindow"), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dispatch("resizewindow"), { mouse = true })

-- Functional keybinds (Hardware control via UWSM apps)
hl.bind("XF86MonBrightnessDown", hl.dispatch("exec", app("brightnessctl set 2%-")), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dispatch("exec", app("brightnessctl set +2%")), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dispatch("exec", app("pamixer -d 2")), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dispatch("exec", app("pamixer -i 2")), { repeating = true })
hl.bind("XF86AudioMicMute", hl.dispatch("exec", app("pamixer --default-source -t")))
hl.bind("XF86AudioMute", hl.dispatch("exec", app("pamixer -t")))

-- Media control via playerctl
hl.bind("XF86AudioPlay", hl.dispatch("exec", app("playerctl play-pause")))
hl.bind("XF86AudioPause", hl.dispatch("exec", app("playerctl play-pause")))
hl.bind("xf86AudioNext", hl.dispatch("exec", app("playerctl next")))
hl.bind("xf86AudioPrev", hl.dispatch("exec", app("playerctl previous")))
hl.bind("xf86Sleep", hl.dispatch("exec", "systemctl suspend"))

-- Keybinds help menu
hl.bind(mainMod .. " + question", hl.dispatch("exec", app(keybinds_yad)))
hl.bind(mainMod .. " + slash", hl.dispatch("exec", app(keybinds_yad)))
hl.bind(mainMod .. " + CTRL + K", hl.dispatch("exec", app(keybinds_yad)))

-- Utilities (Auto-clicker & Night mode)
hl.bind(mainMod .. " + F8",
  hl.dispatch("exec", "kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || " .. app(autoclicker .. " --cps 40")))
hl.bind(mainMod .. " + F9", hl.dispatch("exec", app("hyprsunset --temperature 2500")))
hl.bind(mainMod .. " + F10", hl.dispatch("exec", "pkill hyprsunset"))

-- Window/Session actions
hl.bind(mainMod .. " + Q", hl.dispatch("killactive"))
hl.bind("ALT + F4", hl.dispatch("killactive"))
hl.bind(mainMod .. " + delete", hl.dispatch("exit"))
hl.bind(mainMod .. " + W", hl.dispatch("togglefloating"))
hl.bind(mainMod .. " + SHIFT + G", hl.dispatch("togglegroup"))
hl.bind("ALT + return", hl.dispatch("fullscreen"))
hl.bind(mainMod .. " + ALT + L", hl.dispatch("exec", app("hyprlock")))
hl.bind(mainMod .. " + backspace", hl.dispatch("exec", app("pkill -x wlogout || wlogout -b 4")))

-- Toggle status bar safely
hl.bind("CONTROL + ESCAPE", hl.dispatch("exec", 'pkill "waybar|hyprpanel|wayle" || ' .. app(bar)))

-- Display Zoom
hl.bind(mainMod .. " + CTRL + mouse_down", hl.dispatch("exec", app(zoom .. " in")))
hl.bind(mainMod .. " + CTRL + mouse_up", hl.dispatch("exec", app(zoom .. " out")))

-- Applications & Programs (Exclusively via UWSM)
hl.bind(mainMod .. " + Return", hl.dispatch("exec", app(term)))
hl.bind(mainMod .. " + T", hl.dispatch("exec", app(term)))
hl.bind(mainMod .. " + E", hl.dispatch("exec", app(fileManagerScript .. " " .. fileManager)))
hl.bind(mainMod .. " + C", hl.dispatch("exec", app(editor)))
hl.bind(mainMod .. " + F", hl.dispatch("exec", app(browser)))
hl.bind(mainMod .. " + SHIFT + S", hl.dispatch("exec", app("spotify")))
hl.bind(mainMod .. " + SHIFT + Y", hl.dispatch("exec", app("youtube-music")))
hl.bind("CONTROL + ALT + DELETE", hl.dispatch("exec", app(term .. " -e btop")))
hl.bind("CONTROL + ALT + M", hl.dispatch("exec", app(term .. ' --class "microfetch" --hold -e microfetch')))
hl.bind(mainMod .. " + CTRL + C", hl.dispatch("exec", app("hyprpicker --autocopy --format=hex")))

-- Desktop Shell Launchers
hl.bind(mainMod .. " + A", hl.dispatch("exec", app(launcher .. " drun")))
hl.bind(mainMod .. " + SPACE", hl.dispatch("exec", app(launcher .. " drun")))
hl.bind(mainMod .. " + SHIFT + W", hl.dispatch("exec", app(launcher .. " wallpaper")))
hl.bind(mainMod .. " + Z", hl.dispatch("exec", app(launcher .. " emoji")))
hl.bind(mainMod .. " + SHIFT + T", hl.dispatch("exec", app(launcher .. " tmux")))
hl.bind(mainMod .. " + G", hl.dispatch("exec", app(launcher .. " games")))
hl.bind(mainMod .. " + ALT + K", hl.dispatch("exec", app(keyboardswitch)))
hl.bind(mainMod .. " + V", hl.dispatch("exec", app(clipmanager)))
hl.bind(mainMod .. " + M", hl.dispatch("exec", app(rofimusic)))

-- Notifications & System Toggles
hl.bind(mainMod .. " + SHIFT + N", hl.dispatch("exec", app("swaync-client -t -sw")))
hl.bind(mainMod .. " + SHIFT + Q", hl.dispatch("exec", app("swaync-client -t -sw")))
hl.bind(mainMod .. " + ALT + G", hl.dispatch("exec", app(gamemode)))

-- Screenshot & Screen Capture
hl.bind(mainMod .. " + SHIFT + R", hl.dispatch("exec", app(screen_record .. " a")))
hl.bind(mainMod .. " + CTRL + R", hl.dispatch("exec", app(screen_record .. " m")))
hl.bind(mainMod .. " + P", hl.dispatch("exec", app(screenshot .. " s")))
hl.bind(mainMod .. " + CTRL + P", hl.dispatch("exec", app(screenshot .. " sf")))
hl.bind(mainMod .. " + print", hl.dispatch("exec", app(screenshot .. " m")))
hl.bind(mainMod .. " + ALT + P", hl.dispatch("exec", app(screenshot .. " p")))

-- Floating window cycling (Fixed duplicate keybind crash)
hl.bind(mainMod .. " + Tab", hl.dispatch("cyclenext"))
hl.bind(mainMod .. " + Tab", hl.dispatch("bringactivetotop"))

-- Focus navigation (Arrows)
hl.bind(mainMod .. " + left", hl.dispatch("movefocus", "l"))
hl.bind(mainMod .. " + right", hl.dispatch("movefocus", "r"))
hl.bind(mainMod .. " + up", hl.dispatch("movefocus", "u"))
hl.bind(mainMod .. " + down", hl.dispatch("movefocus", "d"))
hl.bind("ALT + Tab", hl.dispatch("movefocus", "d"))

-- Focus navigation (HJKL)
hl.bind(mainMod .. " + h", hl.dispatch("movefocus", "l"))
hl.bind(mainMod .. " + l", hl.dispatch("movefocus", "r"))
hl.bind(mainMod .. " + k", hl.dispatch("movefocus", "u"))
hl.bind(mainMod .. " + j", hl.dispatch("movefocus", "d"))

-- Workspace relative switching
hl.bind(mainMod .. " + CTRL + right", hl.dispatch("workspace", "r+1"))
hl.bind(mainMod .. " + CTRL + left", hl.dispatch("workspace", "r-1"))
hl.bind(mainMod .. " + CTRL + down", hl.dispatch("workspace", "empty"))

-- Dwindle/Master layout column controls
hl.bind(mainMod .. " + period", hl.dispatch("layoutmsg", "move +col"))
hl.bind(mainMod .. " + comma", hl.dispatch("layoutmsg", "move -col"))

-- Mouse button workspace navigation (Side buttons 275/276)
hl.bind(mainMod .. " + mouse:276", hl.dispatch("workspace", "5"))
hl.bind(mainMod .. " + mouse:275", hl.dispatch("workspace", "6"))
hl.bind(mainMod .. " + ALT + mouse:275", hl.dispatch("workspace", "7"))
hl.bind(mainMod .. " + SHIFT + mouse:276", hl.dispatch("movetoworkspace", "5"))
hl.bind(mainMod .. " + SHIFT + mouse:275", hl.dispatch("movetoworkspace", "6"))
hl.bind(mainMod .. " + SHIFT + ALT + mouse:275", hl.dispatch("movetoworkspace", "7"))
hl.bind(mainMod .. " + CTRL + mouse:276", hl.dispatch("movetoworkspacesilent", "5"))
hl.bind(mainMod .. " + CTRL + mouse:275", hl.dispatch("movetoworkspacesilent", "6"))
hl.bind(mainMod .. " + CTRL + ALT + mouse:275", hl.dispatch("movetoworkspacesilent", "7"))

-- Mouse wheel workspace scrolling
hl.bind(mainMod .. " + mouse_down", hl.dispatch("workspace", "e+1"))
hl.bind(mainMod .. " + mouse_up", hl.dispatch("workspace", "e-1"))

-- Move window to relative workspace
hl.bind(mainMod .. " + CTRL + ALT + right", hl.dispatch("movetoworkspace", "r+1"))
hl.bind(mainMod .. " + CTRL + ALT + left", hl.dispatch("movetoworkspace", "r-1"))

-- Move active window around tiling grid (Arrows)
hl.bind(mainMod .. " + SHIFT + CTRL + left", hl.dispatch("movewindow", "l"))
hl.bind(mainMod .. " + SHIFT + CTRL + right", hl.dispatch("movewindow", "r"))
hl.bind(mainMod .. " + SHIFT + CTRL + up", hl.dispatch("movewindow", "u"))
hl.bind(mainMod .. " + SHIFT + CTRL + down", hl.dispatch("movewindow", "d"))

-- Move active window around tiling grid (HJKL)
hl.bind(mainMod .. " + SHIFT + CTRL + H", hl.dispatch("movewindow", "l"))
hl.bind(mainMod .. " + SHIFT + CTRL + L", hl.dispatch("movewindow", "r"))
hl.bind(mainMod .. " + SHIFT + CTRL + K", hl.dispatch("movewindow", "u"))
hl.bind(mainMod .. " + SHIFT + CTRL + J", hl.dispatch("movewindow", "d"))

-- Special workspace (Scratchpad) management
hl.bind(mainMod .. " + CTRL + S", hl.dispatch("movetoworkspacesilent", "special"))
hl.bind(mainMod .. " + ALT + S", hl.dispatch("movetoworkspacesilent", "special"))
hl.bind(mainMod .. " + S", hl.dispatch("togglespecialworkspace", "special"))

-- Dynamic Workspaces 1-10 generation
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dispatch("workspace", tostring(i)))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dispatch("movetoworkspace", tostring(i)))
  hl.bind(mainMod .. " + CTRL + " .. key, hl.dispatch("movetoworkspacesilent", tostring(i)))
end

-- Inline NixOS system rebuild trigger via standard terminal
hl.bind(mainMod .. " + U", hl.dispatch("exec", app(term .. " -e rebuild")))
