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

    theme.themes = lib.mkOption {
      type = lib.types.either (lib.types.enum [ "all" ]) (lib.types.listOf lib.types.str);
      default = "all";
      description = "All the themes to build";
    };
  };

  config = {
    theme.colors = import ./${config.theme.name}.nix;
  };
}
