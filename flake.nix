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
        pkgs.ghostty
        pkgs.firefox
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = hyprlandPkg;
        portalPackage = portalPkg;
        systemd.enable = false;
        settings = {
          "$mod" = "SUPER";

          # Import this module via homeManagerModules.default, then apply with Home Manager.
          # Available bindings:
          # - SUPER + Return -> Ghostty
          # - SUPER + F -> Firefox
          bind = [
            "$mod, Return, exec, ${pkgs.ghostty}/bin/ghostty"
            "$mod, F, exec, ${pkgs.firefox}/bin/firefox"
          ];
        };
      };
    };
  };
}
