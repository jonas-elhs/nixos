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
    theme = config.theme.themes.${config.theme.name};
  in {
    config.theme.base00 = theme.base00;
    config.theme.base01 = theme.base01;
    config.theme.base02 = theme.base02;
    config.theme.base03 = theme.base03;
    config.theme.base04 = theme.base04;
    config.theme.base05 = theme.base05;
    config.theme.base06 = theme.base06;
    config.theme.base07 = theme.base07;
    config.theme.base08 = theme.base08;
    config.theme.base09 = theme.base09;
    config.theme.base0A = theme.base0A;
    config.theme.base0B = theme.base0B;
    config.theme.base0C = theme.base0C;
    config.theme.base0D = theme.base0D;
    config.theme.base0E = theme.base0E;
    config.theme.base0F = theme.base0F;
  };
}
