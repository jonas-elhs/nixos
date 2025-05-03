{ config, pkgs, lib, ... }: {
  options = {
    system.architecture = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
      description = "The system architecture";
    };
  };
}
