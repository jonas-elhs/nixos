{ config, pkgs, lib, ... }: {
  options = {
    hyprpaper.enable = lib.mkEnableOption "Hyprpaper";
    hyprpaper.wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The path to the wallpaper for all monitors.";
    };
    hyprpaper.wallpapers = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = "";
      description = "The path to the wallpaper for multiple monitors.";
    };
  };

  config = lib.mkIf config.hyprpaper.enable {
    home.packages = with pkgs; [ hyprpaper ];
    services.hyprpaper = {
      enable = true;
      
      settings = {
        preload = if config.hyprpaper.wallpaper != ""
                  then config.hyprpaper.wallpaper
                  else builtins.attrValues config.hyprpaper.wallpapers;
        wallpaper = if config.hyprpaper.wallpaper != ""
                    then ", ${config.hyprpaper.wallpaper}"
                    else builtins.mapAttrs (monitor: path: "${monitor}, ${path}") config.hyprpaper.wallpapers;
      };
    };
  };
}
