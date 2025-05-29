{ config, pkgs, lib, ... }: let
  cfg = config.zen;
  colors = config.theme.colors;
in {
  options.zen = {
    enable = lib.mkEnableOption "Zen";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Zen";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
    } // {
      default = {
        
      };
    }.${cfg.style};
  };
}
