{ config, pkgs, lib, ... }: {
  options = {
    hyprlock.enable = lib.mkEnableOption "Hyprlock";
    hyprlock.style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Hyprlock";
    };
  };

  config = lib.mkIf config.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
    } // {
      default = {
        settings = {
          "$font" = "FiraCode Nerd Font Propo";

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
              font_family = "$font";
              position = "0, 300";
              halign = "center";
              valign = "center";
            }
            {
              text = "cmd[update:43200000] echo \"$(date +\"%A, %0d. %B %Y\")\"";
              font_size = 25;
              font_family = "$font";
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
            font_family = "$font";
            placeholder_text = " $USER";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            position = "0, 100";
            halign = "center";
            valign = "center";
          };
        };
      };
    }.${config.hyprlock.style};
  };
}
