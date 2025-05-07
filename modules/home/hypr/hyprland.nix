{ config, pkgs, lib, ... }: let
  cfg = config.hyprland;
in {
  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
    } // {
      default = let
        active = "rgba(${lib.removePrefix "#" config.theme.colors.accent}ee)";
        inactive = "rgba(${lib.removePrefix "#" config.theme.colors.inactive}ee)";
      in {
        settings = {
          # ---------- MONITORS ---------- #
          monitor = [
            "HDMI-A-2, 3840x2160@60, 0x0, 1.5"
            # Space for waybar
            ", addreserved, 56, 0, 0, 0"
          ];

          # ---------- PROGRAMS ---------- #
          "$terminal" = "kitty";
          "$fileManager" = "dolphin";
          "$appLauncher" = "walker --modules applications";
          "$browser" = "firefox";

          # ---------- AUTOSTART ---------- #
          exec-once = [
            "hyprpaper"
            "hypridle"
            "waybar"

            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
          ];

          # ---------- ENVIRONMENT VARIABLES ---------- #
          env = [];

          # ---------- LOOK AND FEEL ---------- #
          general = {
            border_size = 2;

            gaps_in = 5;
            gaps_out = 20;

            "col.active_border" = active;
            "col.inactive_border" = inactive;

            layout = "master";
          };

          decoration = {
            rounding = 10;
            rounding_power = 2.0;

            layerrule = [
              "blur, logout_dialog"
              "ignorezero, logout_dialog"
            ];

            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };
            blur = {
              enabled = true;
              size = 5;
              passes = 1;

              vibrancy = 0.1696;
            };
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          # ---------- INPUT --------- #
          input = {
            follow_mouse = 1;
            sensitivity = 0.0;
          };

          # ---------- KEYBINDINGS ---------- #
          "$prefix" = "SUPER";

          bind = [
            # General
            "$prefix, Return, exec, uwsm app -- $terminal"
            "$prefix, B, exec, uwsm app -- $browser"
            "$prefix, R, exec, $appLauncher"
            "$prefix, E, exec, $fileManager"

            "$prefix, Q, killactive,"
            "$prefix, M, exit,"

            "$prefix, V, togglefloating,"
            "$prefix, F, fullscreen, 1"
            "$prefix SHIFT, F, fullscreen, 0"

            # Utils
            "$prefix SHIFT, L, exec, loginctl lock-session"
            "$prefix SHIFT, S, exec, screenshot"

            # Move Window Focus
            "$prefix, H, movefocus, l"
            "$prefix, J, movefocus, d"
            "$prefix, K, movefocus, u"
            "$prefix, L, movefocus, r"

            # Switch Workspaces
            "$prefix, 1, workspace, 1"
            "$prefix, 2, workspace, 2"
            "$prefix, 3, workspace, 3"
            "$prefix, 4, workspace, 4"
            "$prefix, 5, workspace, 5"
            "$prefix, 6, workspace, 6"
            "$prefix, 7, workspace, 7"
            "$prefix, 8, workspace, 8"
            "$prefix, 9, workspace, 9"
            "$prefix, 0, workspace, 10"

            # Move Window To Workspace
            "$prefix SHIFT, 1, movetoworkspace, 1"
            "$prefix SHIFT, 2, movetoworkspace, 2"
            "$prefix SHIFT, 3, movetoworkspace, 3"
            "$prefix SHIFT, 4, movetoworkspace, 4"
            "$prefix SHIFT, 5, movetoworkspace, 5"
            "$prefix SHIFT, 6, movetoworkspace, 6"
            "$prefix SHIFT, 7, movetoworkspace, 7"
            "$prefix SHIFT, 8, movetoworkspace, 8"
            "$prefix SHIFT, 9, movetoworkspace, 9"
            "$prefix SHIFT, 0, movetoworkspace, 10"
          ];
          bindm = [
            # Move & Resize Windows
            "$prefix, mouse:272, movewindow"
            "$prefix, mouse:273, resizewindow"
          ];
        };
      };
    }.${cfg.style};
  };
}
