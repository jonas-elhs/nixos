{ config, pkgs, lib, ... }: let
  cfg = config.waybar;
  colors = config.theme.colors;
in {
  options = {
    waybar.enable = lib.mkEnableOption "Waybar";
    waybar.style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Waybar";
    };
    waybar.gpu_hwmon = lib.mkOption {
      type = lib.types.int;
      default = null;
      description = "The hwmon number of the gpu";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
    } // {
      default = let
        accent = colors.accent;
        text = colors.foreground.base;
        background = colors.background.base;
      in {
        settings = {
          bar = {
            layer = "top";
            position = "top";
            margin = "20 20 0 20";
            exclusive = true;

            modules-left = [
              "group/apps"
              "clock"
              "user"
            ];
            modules-center = [
              "hyprland/workspaces"
            ];
            modules-right = [
              "group/hardware"
              "group/information"
              "group/power"
            ];

            "group/apps" = {
              orientation = "inherit";
              modules = [ "custom/launcher" "custom/terminal" "custom/browser" "custom/files" "custom/mail" ];
              drawer = {
                transition-duration = 300;
                children-class = "app-icon";
                transition-left-to-right = true;
              };
            };
            "custom/launcher" = {
              format = "<span color='${accent}'></span>";
              tooltip = false;
              on-click = "walker";
            };
            "custom/terminal" = {
              format = "";
              tooltip-format = "Kitty";
              on-click = "kitty";
            };
            "custom/browser" = {
              format = "";
              tooltip-format = "Firefox";
              on-click = "firefox";
            };
            "custom/files" = {
              format = "";
              tooltip-format = "File Manager";
              on-click = "dolphin";
            };
            "custom/mail" = {
              format = "";
              tooltip-format = "Mail Client";
              on-click = "";
            };

            clock = {
              format = "<span color='${accent}'></span> {:%H:%M}";
              tooltip-format = "{:%A, %d. %B %Y}";
            };

            user = {
              format = "<span color='${accent}'></span> {user}";
            };

            "hyprland/workspaces" = {
              format = "";
              on-click = "activate";
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";
            };

            "group/hardware" = {
              orientation = "inherit";
              modules = [ "cpu" "custom/gpu" "memory" "disk" ];
            };
            cpu = {
              format = "<span color='${accent}'></span> {usage}%";
              tooltip-format = "{load}";
            };
            "custom/gpu" = {
              format = "<span color='${accent}'>󰢮</span> {}%";
              exec = "cat /sys/class/hwmon/hwmon${toString cfg.gpu_hwmon}/device/gpu_busy_percent";
              tooltip = false;
              interval = 1;
            };
            memory = {
              format = "<span color='${accent}'></span> {percentage}%";
              tooltip-format = "{used:0.1f} GiB / {total:0.1f} GiB";
            };
            disk = {
              format = "<span color='${accent}'></span> {percentage_used}%";
              tooltip-format = "{specific_used:0.1f} GB / {specific_total:0.1f} GB";
              unit = "GB";
            };

            "group/information" = {
              orientation = "inherit";
              modules = [ "network" "bluetooth" "wireplumber" ];
            };
            network = {
              format-wifi = "<span color='${accent}'>{icon}</span>";
              tooltip-format-wifi = "{essid} ({signalStrength}%)";
              format-ethernet = "<span color='${accent}'></span>";
              tooltip-format-ethernet = "{ifname} ({bandwidthUpBits}  | {bandwidthDownBits} )";
              format-linked = "<span color='${accent}'> </span>";
              tooltip-format-linked = "{ifname}";
              format-disconnected = "";
              format-icons = [
                "󰤯"
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
              ];
            };
            bluetooth = {
              format-disabled = "";
              format-off = "<span color='${accent}'>󰂲</span>";
              format-on = "<span color='${accent}'>󰂯</span>";
              format-connected = "<span color='${accent}'>󰂯</span>";
              tooltip-format = "{num_connections} Devices";
              tooltip-format-off = "Off";
              on-click = "bluetooth-toggle";
            };
            wireplumber = {
              format = "<span color='${accent}'>{icon}</span>";
              format-low = "<span color='${accent}'>x</span> {volume}%"; # not working
              format-none = "<span color='${accent}'>x</span> {volume}%"; # not working
              format-muted = "<span color='${accent}'></span>";
              tooltip-format = "{volume}%";
              on-click = "audio-toggle";

              format-icons = [ "" "" "" ];

              states = {
                none = 0;
                low = 50;
              };
            };

            "group/power" = {
              orientation = "inherit";
              modules = [ "custom/shutdown" "custom/suspend" "custom/hibernate" "custom/logout" "custom/lock" "custom/reboot" ];
              drawer = {
                transition-duration = 300;
                children-class = "power-icon";
                transition-left-to-right = false;
              };
            };
            "custom/shutdown" = {
              format = "<span color='${accent}'>⏻</span>";
              on-click = "systemctl poweroff";
              tooltip-format = "Shutdown";
            };
            "custom/reboot" = {
              format = "";
              on-click = "systemctl reboot";
              tooltip-format = "Reboot";
            };
            "custom/lock" = {
              format = "";
              on-click = "loginctl lock-session";
              tooltip-format = "Lock";
            };
            "custom/logout" = {
              format = "󰍃";
              on-click = "hyprctl dispatch exit";
              tooltip-format = "Logout";
            };
            "custom/hibernate" = {
              format = "";
              on-click = "systemctl hibernate";
              tooltip-format = "Hibernate";
            };
            "custom/suspend" = {
              format = "";
              on-click = "systemctl suspend";
              tooltip-format = "Suspend";
            };
          };
        };

        style = ''
          * {
            font-family: FiraCode Nerd Font Propo, Roboto, Helvetica, Arial, sans-serif;
            font-size: 18px;
            min-height: 0;
            background: transparent;
            border-style: none;
            color: ${text};
          }

          tooltip {
            background: rgba(43, 48, 59, 0.5);
            border: 1px solid rgba(100, 114, 125, 0.5);
          }

          #apps,
          #clock,
          #user,
          #workspaces,
          #hardware,
          #information,
          #power {
            border-radius: 10px;
            background: alpha(${background}, 0.9);
            padding: 0px 10px;
            margin: 0px 10px;
            border: 2px solid ${accent};
          }

          #power {
            margin-right: 0px;
            padding: 0px 12px;
          }
          .power-icon label {
            font-size: 15px;
            margin: 0px 20px 0px 0px;
          }

          #apps {
            margin-left: 0px;
            padding: 0px 12px;
          }
          .app-icon label {
            font-size: 15px;
            margin: 0px 0px 0px 20px;
          }

          #hardware label,
          #information label {
            margin: 0 10px;
          }

          #workspaces button {
            background: ${text};
            padding: 0px 0px;
            margin: 10px 5px;
            transition: all 0.2s ease;
            border-radius: 10px;
            border-style: none;
          }
          #workspaces button:hover {
            background: ${text};
            border-color: rgba(0, 0, 0, 0);
            border-style: none;
            box-shadow: none;
          }
          #workspaces button.active {
            background: ${accent};
            padding: 0px 30px;
          }
          #workspaces button.active:hover {
            background: ${accent};
          }
          #workspaces button label {
            font-size: 12px;
          }
        '';
      };      
    }.${cfg.style};
  };
}
