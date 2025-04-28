{ config, pkgs, lib, ... }: {
  options = {
    bluetooth.enable = lib.mkEnableOption "Bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
