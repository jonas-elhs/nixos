{ config, pkgs, lib, ... }: {
  options = {
    XXX.enable = lib.mkEnableOption "XXX";
    XXX.style = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The style of XXX";
    };
  };

  config = lib.mkIf config.XXX.enable {
    programs.XXX = {
      enable = true;
    } // {
      
    }.${config.XXX.style};
  };
}
