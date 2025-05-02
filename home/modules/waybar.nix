{ config, pkgs, lib, ... }: let
  cfg = config.waybar;
in {
  options = {
    waybar.enable = lib.mkEnableOption "Waybar";
    waybar.style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Waybar";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
    } // {
      default = let
        accent = config.theme.colors.accent;
        text = config.theme.colors.foreground;
        background = config.theme.colors.background;
      in {
        settings = {
          bar = {
            layer = "top";
            position = "top";
            margin = "20 0 0 20";
            exclusive = false;

            modules-left = [
              "clock"
            ];
            modules-center = [
              "hyprland/workspaces"
            ];
            modules-right = [
              "group/connections"
              "group/hardware"
              # "privacy"
              "wireplumber"
              "custom/power"
            ];

            # GROUPS #
            "group/connections" = {
              orientation = "inherit";
              modules = [ "network" "bluetooth" ];
            };
            "group/hardware" = {
              orientation = "inherit";
              modules = [ "cpu" "memory" ];
            };

            # MODULES #
            clock = {
              format = "<span color='${accent}'></span> {:%H:%M}";
              tooltip-format = "{:%A, %d. %B %Y}";
            };

            "hyprland/workspaces" = {
              format = "";
              persistent-workspaces = {
                "*" = 5;
              };
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
              tooltip-format-off = "Off";
              format-on = "<span color='${accent}'>󰂯</span>";
              format-connected = "<span color='${accent}'>󰂯</span>";
              tooltip-format = "{num_connections} Devices";
              on-click = "bluetooth-toggle";
            };

           cpu = {
              format = "<span color='${accent}'></span> {usage}%";
              tooltip-format = "{load}";
            };
            memory = {
              format = "<span color='${accent}'></span> {percentage}%";
              tooltip = true;
              tooltip-format = "{used:0.1f} GiB / {total:0.1f} GiB";
            };

  /*"privacy": {
    "icon-spacing": 4,
    "icon-size": 20,
    "transition-duration": 250,
    "modules": [
      {
        "type": "screenshare",
        "tooltip": true,
        "tooltip-icon-size": 24
      },
      {
        "type": "audio-out",
        "tooltip": true,
        "tooltip-icon-size": 24
      },
      {
        "type": "audio-in",
        "tooltip": true,
        "tooltip-icon-size": 24
      }
    ]
  },*/

            wireplumber = {
              format = "<span color='${accent}'></span> {volume}%";
              format-low = " {volume}%"; # not working
              format-none = " {volume}%"; # not working
              format-muted = "<span color='${accent}'></span> {volume}%";
              on-click = "audio-toggle";

              states = {
                none = 0;
                low = 50;
              };
            };

            "custom/power" = {
              format = "<span color='${accent}'>⏻</span>";
              on-click = "wlogout";
              tooltip = false;
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

          #clock,
          #workspaces,
          #connections,
          #hardware,
          #privacy,
          #user,
          #wireplumber,
          #custom-power {
            border-radius: 10px;
            background: alpha(${background}, .9);
            padding: 0px 10px;
            margin: 0px 5px 6px 5px;
            box-shadow: 2px 2px 2px 0px #101010;
          }

          #clock {
            margin-left: 0px;
          }
          #custom-power {
            margin-right: 20px;
            padding: 0px 12px;
          }

          #connections label,
          #hardware label {
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
