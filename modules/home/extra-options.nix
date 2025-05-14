{ config, pkgs, lib, ... }: {
  options = {
    home.groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "The groups of a user";
    };

    theme.name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The default color theme of the system";
    };
  };
}
