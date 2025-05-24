{ config, pkgs, lib, colors, ... }: let
  cfg = config.hypridle;
  colors = config.theme.colors;
in {
  options.hypridle = {
    enable = lib.mkEnableOption "Hypridle";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Hypridle";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;
    } // {
      default = {
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            # Lock System - 5 Minutes
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }

            # Dim Screen - 10 Minutes
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }

            # Suspend System - 30 minutes
            {
              timeout = 1800;
              on-timeout = "systemctl hibernate";
            }
          ];
        };
      };
    }.${cfg.style};
  };
}
