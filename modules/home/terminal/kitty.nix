{ config, pkgs, lib, ... }: let
  cfg = config.kitty;
  colors = config.theme.colors;
in {
  options.kitty = {
    enable = lib.mkEnableOption "Kitty Terminal";
    style = lib.mkOption {
      type = lib.types.str; 
      default = "default";
      description = "The style of Kitty Terminal";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    } // {
      default = {
        shellIntegration = {
          enableFishIntegration = true;
          mode = "no-rc no-cursor";
        };
        font = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font Mono";
          size = 12;
        };
        keybindings = {
          "ctrl+c" = "copy_or_interrupt";
          "ctrl+v" = "paste_from_clipboard";
        };
        settings = {
          background_opacity = 0.5;
          window_padding_width = 8;
          background_blur = 0;
          cursor_trail = 1;

          # Theme
          foreground = colors.foreground.base;
          background = colors.background.dark;
          selection_foreground = colors.background.base;
          selection_background = colors.foreground.base;
          url_color = colors.url;
          cursor = colors.foreground.base;

          color0 = colors.base00;
          color1 = colors.base01;
          color2 = colors.base02;
          color3 = colors.base03;
          color4 = colors.base04;
          color5 = colors.base05;
          color6 = colors.base06;
          color7 = colors.base07;
          color8 = colors.base08;
          color9 = colors.base09;
          color10 = colors.base0A;
          color11 = colors.base0B;
          color12 = colors.base0C;
          color13 = colors.base0D;
          color14 = colors.base0E;
          color15 = colors.base0F;
        };
      };
    }.${cfg.style};
  };
}
