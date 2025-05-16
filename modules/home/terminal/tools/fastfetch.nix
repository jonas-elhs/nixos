{ config, pkgs, lib, colors, ... }: let
  cfg = config.fastfetch;
in {
  options.fastfetch = {
    enable = lib.mkEnableOption "Fastfetch";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Fastfetch";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
    } // {
      default = let
        hardware = lib.elemAt colors.gradient4 0;
        software = lib.elemAt colors.gradient4 1;
        software2 = lib.elemAt colors.gradient4 2;
        peripherals = lib.elemAt colors.gradient4 3;

        text = colors.foreground;
      in {
        settings = {
          logo = {
            padding = {
              top = 0;
            };
          };

          display = {
            size = {
              binaryPrefix = "si";
            };
            color = {
              output = text;
            };
          };

          modules = [
            {
              type = "custom";
              format = "┌──────────────────────Hardware──────────────────────┐";
            }
            {
              type = "host";
              keyColor = hardware;
            }
            {
              type = "cpu";
              format = "{name} ({cores-online} Cores | {freq-base})";
              keyColor = hardware;
            }
            {
              type = "gpu";
              format = "{vendor} {name} ({core-count} Cores | {frequency} | {dedicated-total})";
              driverSpecific = true;
              hideType = "integrated";
              keyColor = hardware;
            }
            {
              type = "memory";
              format = "{total}";
              keyColor = hardware;
            }
            {
              type = "disk";
              format = "{size-total} - {filesystem}";
              showExternal = false;
              keyColor = hardware;
            }
            {
              type = "custom";
              format = "└────────────────────────────────────────────────────┘";
            }

            "break"

            {
              type = "custom";
              format = "┌──────────────────────Software──────────────────────┐";
            }
            {
              type = "os";
              format = "{name} {version-id}";
              keyColor = software;
            }
            {
              type = "kernel";
              keyColor = software;
            }
            {
              type = "initsystem";
              keyColor = software;
            }
            {
              type = "bootmgr";
              keyColor = software;
            }
            {
              type = "packages";
              keyColor = software;
            }

            "break"

            {
              type = "lm";
              keyColor = software2;
            }
            {
              type = "de";
              keyColor = software2;
            }
            {
              type = "wm";
              keyColor = software2;
            }
            {
              type = "font";
              keyColor = software2;
            }
            {
              type = "terminal";
              keyColor = software2;
            }
            {
              type = "editor";
              keyColor = software2;
            }
            {
              type = "shell";
              keyColor = software2;
            }
            {
              type = "custom";
              format = "└────────────────────────────────────────────────────┘";
            }

            "break"

            {
              type = "custom";
              format = "┌────────────────────Peripherals─────────────────────┐";
            }
            {
              type = "display";
              format = "{width}x{height} @ {refresh-rate} Hz (as {scaled-width}x{scaled-height})";
              keyColor = peripherals;
            }
            {
              type = "mouse";
              keyColor = peripherals;
            }
            {
              type = "keyboard";
              keyColor = peripherals;
            }
            {
              type = "custom";
              format = "└────────────────────────────────────────────────────┘";
            }

            "break"

            {
              type = "colors";
              symbol = "circle";
            }
          ];
        };
      };
    }.${cfg.style};
  };
}
