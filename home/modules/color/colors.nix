{ config, pkgs, lib, ... }: {
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

    theme.base00 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base00 color of the theme";
    };
    theme.base01 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base01 color of the theme";
    };
    theme.base02 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base02 color of the theme";
    };
    theme.base03 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base03 color of the theme";
    };
    theme.base04 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base04 color of the theme";
    };
    theme.base05 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base05 color of the theme";
    };
    theme.base06 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base06 color of the theme";
    };
    theme.base07 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base07 color of the theme";
    };
    theme.base08 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base08 color of the theme";
    };
    theme.base09 = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base09 color of the theme";
    };
    theme.base0A = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base0A color of the theme";
    };
    theme.base0B = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base0B color of the theme";
    };
    theme.base0C = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base0C color of the theme";
    };
    theme.base0D = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base0D color of the theme";
    };
    theme.base0E = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base0E color of the theme";
    };
    theme.base0F = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The base0F color of the theme";
    };
  };

  config = let
    user_theme = config.theme.themes.${config.theme.name};
  in {
    theme.base00 = user_theme.base00;
    theme.base01 = user_theme.base01;
    theme.base02 = user_theme.base02;
    theme.base03 = user_theme.base03;
    theme.base04 = user_theme.base04;
    theme.base05 = user_theme.base05;
    theme.base06 = user_theme.base06;
    theme.base07 = user_theme.base07;
    theme.base08 = user_theme.base08;
    theme.base09 = user_theme.base09;
    theme.base0A = user_theme.base0A;
    theme.base0B = user_theme.base0B;
    theme.base0C = user_theme.base0C;
    theme.base0D = user_theme.base0D;
    theme.base0E = user_theme.base0E;
    theme.base0F = user_theme.base0F;
  };
}
