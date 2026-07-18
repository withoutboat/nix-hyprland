-- Helper functions to simplify rule creation
local function window(pattern, property)
  -- If pattern is a string, assume it's the window class
  local match_cfg = type(pattern) == "string" and { class = pattern } or pattern

  -- Merge match configuration with properties
  local rule = { match = match_cfg }
  for k, v in pairs(property) do rule[k] = v end
  hl.window_rule(rule)
end

local function layer(namespace, property)
  local rule = { match = { namespace = namespace } }
  for k, v in pairs(property) do rule[k] = v end
  hl.layer_rule(rule)
end

-- ==========================================
-- LAYER RULES (UI Blur & Translucency)
-- ==========================================
layer("rofi", { blur = true, ignore_alpha = 0.7 })
layer("^(swaync-control-center)$", { blur = true, ignore_alpha = 0.7 })
layer("^(swaync-notification-window)$", { blur = true, ignore_alpha = 0.8 })
layer(
  "^(bar-.*|notifications-window|mediamenu|notificationsmenu|calendarmenu|audiomenu|networkmenu|energymenu|dashboardmenu)$",
  { blur = true, ignore_alpha = 0.7 })

-- ==========================================
-- WINDOW RULES (Opacity & State)
-- ==========================================

-- Fully opaque apps (Browsers)
window("^([Ff]irefox|[Zz]en(-beta|-browser)?|[Ff]loorp|[Bb]rave-browser(-beta|-dev|-unstable)?)$",
  { opacity = "1.00 1.00" })

-- Semi-transparent Tiling Apps (Development & Tools)
window("^(Emacs|obsidian|proton.vpn.app.gtk|heroic)$", { opacity = "0.90 0.80" })
window("^(gcr-prompter)$", { opacity = "0.90 0.80" })
window({ title = "^(Hyprland Polkit Agent)$" }, { opacity = "0.90 0.80" })

-- Terminals & Text Editors (Added ghostty here)
window("^(ghostty|kitty|[Aa]lacritty|org.wezfurlong.wezterm|nvim-wrapper)$", { opacity = "0.80 0.70" })

-- File Managers & System Utilities
window("^(org.gnome.Nautilus|[Tt]hunar|pcmanfm|org.kde.dolphin)$", { opacity = "0.80 0.70" })
window("^(gnome-disks|thunar-volman-settings|file-roller|org.gnome.FileRoller|io.github.ilya_zlobintsev.LACT)$",
  { opacity = "0.80 0.70" })
window("^(VSCodium|codium-url-handler|code|code-url-handler)$", { opacity = "0.80 0.70" })
window("^(qt5ct|qt6ct|gjs|com.github.tchx84.Flatseal|hu.kramo.Cartridges|com.obsproject.Studio|gnome-boxes)$",
  { opacity = "0.80 0.70" })

-- Media & Audio Apps
window("^([Ss]team|steamwebhelper|[Ss]potify|com.github.th_ch.youtube_music)$", { opacity = "0.80 0.70" })
window({ title = "^(Kvantum Manager)$" }, { opacity = "0.80 0.70" })

-- Floating Windows (Dialogs, Mixers, Control Panels)
window("^(com.github.rafostar.Clapper)$", { opacity = "0.90 0.80", float = true })
window("^([Ll]utris|net.lutris.Lutris)$", { opacity = "0.90 0.80" })
window("^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$", { opacity = "0.90 0.80" })
window("^(org.kde.ark|nwg-look|yad|app.drey.Warp|net.davidotek.pupgui2|Signal|io.gitlab.theevilskeleton.Upscaler)$",
  { float = true })
window("^(pavucontrol|org.pulseaudio.pavucontrol|blueman-manager|.blueman-manager-wrapped)$", { float = true })
window("^(nm-applet|nm-connection-editor|org.kde.polkit-kde-authentication-agent-1)$", { float = true })
window("^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde)$", { opacity = "0.80 0.70" })

-- Popups & Specific Overlays
window("^(microfetch)$", { opacity = "0.80 0.70", float = true, center = true, size = "802 261" })
window("^(eog)$", { float = true })
window("^(qt5ct)$", { float = true })

-- Browser Picture-in-Picture
window({ title = "^(Picture-in-Picture)$", class = "^([Zz]en(-beta|-browser)?|[Ff]loorp|[Ff]irefox)$" },
  { float = true, pin = true })

-- ==========================================
-- GAME MODE & GRAPHICS ENGINE RULES
-- ==========================================
window({ tag = "games" },
  { content = "game", sync_fullscreen = true, fullscreen = true, border_size = 0, no_shadow = true, no_blur = true, no_anim = true })
window({ content = "3" }, { tag = "+games" })
window("^(steam_app.*|steam_app_\\d+|gamescope)$", { tag = "+games" })
window("(Waydroid)", { tag = "+games" })
window("(osu!)", { tag = "+games" })
window("^(com.libretro.RetroArch|[Rr]etro[Aa]rch)$", { tag = "+games" })

-- Godot Engine Development Layout Fixes
window({ initial_title = "^(Godot)$", initial_class = "^(Godot)$" }, { tile = true })
window({ title = "^((.*)(DEBUG))", class = "^(Godot)$" }, { float = true })
window({ initial_title = "^(.*)(DEBUG)(.*)$", class = "^(Godot)$" }, { float = true })
