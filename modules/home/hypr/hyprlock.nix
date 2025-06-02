{ config, pkgs, lib, ... }: let
  cfg = config.hyprlock;
  colors = config.theme.colors;
  layout = config.layout;
in {
  options.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Hyprlock";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
    } // {
      default = let
        font = "FiraCode Nerd Font Propo";
        text = "rgb(${lib.removePrefix "#" colors.foreground.base})";
        accent = "rgb(${lib.removePrefix "#" colors.accent})";
        error = "rgb(${lib.removePrefix "#" colors.error})";
      in {
        settings = {
          general = {
            hide_cursor = true;
          };

          animations = {
            enabled = true;
            bezier = "linear, 1, 1, 0, 0";
            animation = [
              "fadeIn, 1, 8, linear"
              "fadeOut, 1, 3, linear"
              "inputFieldDots, 1, 1, linear"
            ];
          };

          background = {
            path = "~/wallpapers/moon.png";
            blur_size = 5;
            blur_passes = 1;
            vibrancy_darkness = 0;
          };

          label = [
            {
              text = "$TIME";
              font_size = 90;
              font_family = font;
              color = text;
              position = "0, 300";
              halign = "center";
              valign = "center";
            }
            {
              text = "cmd[update:43200000] echo \"$(date +\"%A, %0d. %B %Y\")\"";
              font_size = 25;
              font_family = font;
              color = text;
              position = "0, 220";
              halign = "center";
              valign = "center";
            }
          ];

          input-field = {
            size = "300, 60";
            outline_thickness = 4;
            dots_size = 0.2;
            dots_spacing = 0.5;
            dots_center = true;
            fade_on_empty = false;
            hide_input = false;
            font_family = font;
            placeholder_text = " $USER";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            position = "0, 100";
            halign = "center";
            valign = "center";

            outer_color = accent;
            inner_color = text;
            font_color = "#000000";
            fail_color = error;
            check_color = accent;
          };
        };
      };
    }.${cfg.style};
  };
}
