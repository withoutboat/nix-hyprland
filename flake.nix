{
  description = "Minimal Hyprland Home Manager module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, hyprland, ... }@inputs: {
    homeManagerModules.default = { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      hyprlandPkg = hyprland.packages.${system}.hyprland;
      portalPkg = hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    in
    {
      home.packages = [
        pkgs.uwsm
        pkgs.pavucontrol
        pkgs.swappy
        pkgs.cliphist
        pkgs.pamixer
        pkgs.hyprsunset
        pkgs.btop
        pkgs.hyprpicker
        pkgs.hyprpolkitagent
        pkgs.hyprpaper
        pkgs.hyprlock
        pkgs.hypridle
        pkgs.waybar
        pkgs.wofi
        pkgs.mako
        pkgs.wl-clipboard
        pkgs.grim
        pkgs.slurp
        pkgs.brightnessctl
        pkgs.playerctl
        pkgs.breeze-hacked-cursor-theme
        pkgs.telegram-desktop
        pkgs.xdg-desktop-portal-gtk
      ];

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        GDK_BACKEND = "wayland,x11,*";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          portalPkg
        ];
        config = {
          common = {
            default = [ "hyprland" "gtk" ];
          };
          hyprland = {
            default = [ "hyprland" "gtk" ];
          };
        };
      };

      programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        settings.main = {
          layer = "top";
          position = "bottom";
          height = 36;
          spacing = 4;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "custom/search" ];
          modules-right = [ "clock" ];

          "hyprland/workspaces" = {
            format = "{name}";
            all-outputs = true;
            active-only = false;
            on-click = "activate";
          };

          "custom/search" = {
            format = "  Search applications...";
            tooltip = false;
            on-click = "uwsm app -- ${pkgs.wofi}/bin/wofi --show drun";
          };

          clock = {
            format = "{:%H:%M  %d.%m.%Y}";
            format-alt = "{:%H:%M:%S  %A, %d %B %Y}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
        };
        style = ''
          * {
            border: none;
            border-radius: 0;
            font-family: "JetBrainsMono Nerd Font", "Noto Sans", sans-serif;
            font-size: 13px;
            min-height: 0;
          }

          window#waybar {
            background-color: rgba(24, 24, 37, 0.95);
            color: #cdd6f4;
            border-top: 1px solid rgba(203, 166, 247, 0.2);
          }

          #workspaces {
            margin: 0 4px;
          }

          #workspaces button {
            padding: 2px 10px;
            margin: 3px 2px;
            border-radius: 6px;
            color: #a6adc8;
            background: rgba(49, 50, 68, 0.5);
            transition: all 0.2s ease;
          }

          #workspaces button:hover {
            background: rgba(203, 166, 247, 0.2);
            color: #cdd6f4;
          }

          #workspaces button.active {
            color: #11111b;
            background: #cba6f7;
            font-weight: bold;
          }

          #workspaces button.urgent {
            background: #f38ba8;
            color: #11111b;
          }

          #custom-search {
            background-color: #313244;
            color: #a6adc8;
            padding: 4px 20px;
            margin: 3px 0;
            border-radius: 8px;
            border: 1px solid #45475a;
            min-width: 260px;
            transition: all 0.2s ease;
          }

          #custom-search:hover {
            background-color: #45475a;
            color: #cdd6f4;
            border-color: #cba6f7;
          }

          #clock {
            padding: 2px 14px;
            margin: 3px 6px;
            background-color: rgba(49, 50, 68, 0.5);
            color: #cdd6f4;
            border-radius: 6px;
            font-weight: 500;
          }
        '';
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = hyprlandPkg;
        portalPackage = portalPkg;
        systemd.enable = false;
      };

      home.pointerCursor = {
        enable = true;
        package = pkgs.breeze-hacked-cursor-theme;
        name = "Breeze_Hacked";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
        hyprcursor.enable = true;
      };

      xdg.configFile."hypr/hyprland.lua".source = ./lua/hyprland.lua;
    };
  };
}
