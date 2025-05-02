{ config, pkgs, lib, ... }: let
    user_theme = config.theme.themes.${config.theme.name};
  in {
  options = {
    theme.themes = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "All themes in base16 format";
    };

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
    theme.colors = config.theme.themes.${config.theme.name};
  };
}
