{ config, pkgs, lib, ... }: {
  options = {
    theme.name = lib.mkOption {
      type = lib.types.str;
      default = "nordic";
      description = "The name of the theme";
    };

    theme.colors = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "The colors of the theme";
    };
  };

  config = {
    theme.colors = import ./${config.theme.name}.nix;
  };
}
