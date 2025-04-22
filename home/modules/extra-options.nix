{ config, pkgs, lib, ... }: {
  options = {
    home.groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "The groups of a user";
    };
  };
}
