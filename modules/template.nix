{ config, pkgs, lib, ... }: {
  options = {
    XXX.enable = lib.mkEnableOption "Enables XXX";
  };

  config = lib.mkIf config.XXX.enable {
    programs.XXX = {
      enable = true;
    };
  };
}
