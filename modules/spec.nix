{ pkgs, ... }:

{
  xdg.configFile."hypr/spec.lua".text = ''
    -- ==========================================
    -- DYNAMIC ENVIRONMENT VARIABLES FROM NIX SPEC
    -- ==========================================
    
    mainMod = "SUPER"
    
    -- Keyboard Layout Config
    kbdLayout = "us"
    kbdVariant = ""
    capslockAsESC = true
    
    -- Applications (Direct paths from Nix Store to bypass global path dependency)
    term = "${pkgs.ghostty}/bin/ghostty"
    browser = "${pkgs.firefox}/bin/firefox"
    editor = "${pkgs.vscode}/bin/code"
    fileManager = "${pkgs.xfce.thunar}/bin/thunar"
    fileManagerScript = ""
    
    -- Shell Toggles
    launcher = "${pkgs.wofi}/bin/wofi --show"
    bar = "${pkgs.waybar}/bin/waybar"
    
    -- Utilities & Scripts (Fixed dollar-sign interpolation for Nix)
    screenshot = "${pkgs.grim}/bin/grim -g \"''$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"
    screen_record = "${pkgs.wf-recorder}/bin/wf-recorder"
    clipmanager = "${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi --dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
    keybinds_yad = "${pkgs.yad}/bin/yad --text='Keybinds Quick Sheet'"
    keyboardswitch = "${pkgs.hyprland}/bin/hyprctl switchxkblayout keyboard next"
    autoclicker = "clickhole" 
    rofimusic = "${pkgs.spotify}/bin/spotify"
    gamemode = "${pkgs.hyprland}/bin/hyprctl keyword animations:enabled 0"
    zoom = "${pkgs.hyprland}/bin/hyprctl misc:cursor_zoom_factor"
  '';
}
