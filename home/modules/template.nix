{ config, pkgs, lib, ... }: let
  cfg = config.XXX;
in {
  options = {
    XXX.enable = lib.mkEnableOption "XXX";
    XXX.style = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The style of XXX";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.XXX = {
      enable = true;
    } // {
      
    }.${cfg.style};
  };
}
