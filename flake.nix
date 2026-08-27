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
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = hyprlandPkg;
        portalPackage = portalPkg;
        systemd.enable = false;
      };

      xdg.configFile."hypr/hyprland.lua".source = ./lua/hyprland.lua;
    };
  };
}
