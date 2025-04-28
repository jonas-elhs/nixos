{ config, pkgs, lib, ... }: {
  options = {
    XXX.enable = lib.mkEnableOption "XXX";
  };

  config = lib.mkIf config.XXX.enable {
    
  };
}
