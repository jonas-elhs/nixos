{ config, pkgs, lib, colors, ... }: let
  cfg = config.XXX;
in {
  options.XXX = {
    enable = lib.mkEnableOption "XXX";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of XXX";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.XXX = {
      enable = true;
    } // {
      default = {
        
      };
    }.${cfg.style};
  };
}
