{ config, lib, pkgs, ... }:

let
  cfg = config.programs.swappy;

  screenshotScript = pkgs.writeShellScriptBin "screenshot" ''
    mkdir -p "$HOME/Pictures/Screenshots"
    case "$1" in
      --full)
        ${pkgs.grim}/bin/grim - | ${cfg.package}/bin/swappy -f -
        ;;
      --clipboard|--copy|-c)
        GEOM=$(${pkgs.slurp}/bin/slurp -d -b 1e1e2ecc -c cba6f7ff -s cba6f733)
        if [ -n "$GEOM" ]; then
          ${pkgs.grim}/bin/grim -g "$GEOM" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png
        fi
        ;;
      *)
        GEOM=$(${pkgs.slurp}/bin/slurp -d -b 1e1e2ecc -c cba6f7ff -s cba6f733)
        if [ -n "$GEOM" ]; then
          ${pkgs.grim}/bin/grim -g "$GEOM" - | ${cfg.package}/bin/swappy -f -
        fi
        ;;
    esac
  '';

  screenshotDesktop = pkgs.makeDesktopItem {
    name = "screenshot";
    desktopName = "Take Screenshot";
    genericName = "Screenshot Tool";
    comment = "Select a region and annotate or save screenshot";
    exec = "${screenshotScript}/bin/screenshot";
    icon = "camera-photo";
    categories = [ "Utility" ];
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.swappy.settings = {
      Default = {
        save_dir = lib.mkDefault "$HOME/Pictures/Screenshots";
        save_filename_format = lib.mkDefault "screenshot-%Y%m%d-%H%M%S.png";
        show_panel = lib.mkDefault true;
        line_size = lib.mkDefault 5;
        text_size = lib.mkDefault 20;
        text_font = lib.mkDefault "sans-serif";
        paint_mode = lib.mkDefault "brush";
        early_exit = lib.mkDefault true;
        fill_shape = lib.mkDefault false;
      };
    };

    home.packages = [
      screenshotScript
      screenshotDesktop
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard
    ];
  };
}
