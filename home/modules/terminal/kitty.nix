{ config, pkgs, lib, ... }: let
  cfg = config.kitty;
in {
  options = {
    kitty.enable = lib.mkEnableOption "Kitty Terminal";
    kitty.style = lib.mkOption {
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
          foreground = config.theme.colors.foreground;
          background = config.theme.colors.background;
          selection_foreground = config.theme.colors.background;
          selection_background = config.theme.colors.foreground;
          url_color = "#88C0D0";
          cursor = config.theme.colors.foreground;

          color0 = config.theme.colors.base00;
          color1 = config.theme.colors.base01;
          color2 = config.theme.colors.base02;
          color3 = config.theme.colors.base03;
          color4 = config.theme.colors.base04;
          color5 = config.theme.colors.base05;
          color6 = config.theme.colors.base06;
          color7 = config.theme.colors.base07;
          color8 = config.theme.colors.base08;
          color9 = config.theme.colors.base09;
          color10 = config.theme.colors.base0A;
          color11 = config.theme.colors.base0B;
          color12 = config.theme.colors.base0C;
          color13 = config.theme.colors.base0D;
          color14 = config.theme.colors.base0E;
          color15 = config.theme.colors.base0F;
        };
      };
    }.${cfg.style};
  };
}
