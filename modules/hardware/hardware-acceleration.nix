{ config, pkgs, lib, ... }: {
  options = {
    hardware-acceleration.enable = lib.mkEnableOption "Hardware Acceleration";
  };

  config = lib.mkIf config.hardware-acceleration.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
