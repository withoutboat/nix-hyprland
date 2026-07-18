{
  description = "Hyprland Lua Configuration Flake for Home Manager";

  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, hyprland, ... }@inputs: {
    homeManagerModules.default = { config, lib, pkgs, ... }:
    let
      hyprlandPkg = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPkg = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    in
    {
      home.packages = with pkgs; [
        pavucontrol
        swappy
        cliphist
        pamixer
        hyprsunset
        btop
        hyprpicker
        hyprpolkitagent
        hyprpaper     # Wallpaper daemon
        hyprlock      # Screen locker
        hypridle      # Idle management
        waybar        # Status bar
        wofi          # Application launcher
        mako          # Notification daemon
        wl-clipboard  # Clipboard management
        grim          # Screenshot tool
        slurp         # Region selector
        brightnessctl # Hardware control
        playerctl     # Media control

      ];
      
      wayland.windowManager.hyprland = {
        enable = true;
        package = hyprlandPkg;
        portalPackage = portalPkg;
        systemd.enable = false;
      };

      systemd.user.services.hyprpolkitagent = {
        Unit = {
          Description = "Hyprpolkitagent - Polkit authentication agent";
          WantedBy = [ "graphical-session.target" ];
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
        config.common = {
          default = [ "hyprland" "gtk" ];
        };
      }; 

      services.awww.enable = true;

      xdg.configFile = {
      "hypr" = {
        source = ./lua;
        recursive = true;
      };
    
      "hypr/icons" = {
        source = ./icons;
        recursive = true;
      };
    }; 
  };
}
