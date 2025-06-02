{ config, pkgs, lib, ... }: let
  cfg = config.hyprpaper;
  colors = config.theme.colors;
  layout = config.layout;
in {
  options.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper";
    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The path to the wallpaper for all monitors.";
    };
    wallpapers = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = "";
      description = "The path to the wallpaper for multiple monitors.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ hyprpaper ];
    services.hyprpaper = {
      enable = true;
      
      settings = {
        preload = if cfg.wallpaper != ""
                  then cfg.wallpaper
                  else builtins.attrValues cfg.wallpapers;
        wallpaper = if cfg.wallpaper != ""
                    then ", ${cfg.wallpaper}"
                    else builtins.mapAttrs (monitor: path: "${monitor}, ${path}") cfg.wallpapers;
      };
    };
  };
}
