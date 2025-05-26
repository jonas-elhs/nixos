{ config, pkgs, lib, ... }: let
  cfg = config.hyprland;
  colors = config.theme.colors;
in {
  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Hyprland";
    };
    persistentWorkspaces = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 0;
      example = 5;
      description = "The amount of persistent workspaces to have";
    };
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Plugins to add to hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = cfg.plugins;
    } // {
      default = let
        active = "rgba(${lib.removePrefix "#" colors.accent}ee)";
        inactive = "rgba(${lib.removePrefix "#" colors.inactive}ee)";
      in {
        settings = {
          # ---------- MONITORS ---------- #
          monitor = [
            "HDMI-A-2, 3840x2160@60, 0x0, 1.5"
          ];

          workspace = builtins.genList (n: "${toString (n+1)}, persistent:true") cfg.persistentWorkspaces;

          # ---------- PROGRAMS ---------- #
          "$terminal" = "kitty";
          "$fileManager" = "dolphin";
          "$appLauncher" = "walker --modules applications";
          "$themeSwitcher" = "walker --modules themes";
          "$wallpaperSwitcher" = "walker --modules wallpapers";
          "$browser" = "zen";

          # ---------- AUTOSTART ---------- #
          exec-once = [
            "waybar"

            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
          ];

          # ---------- ENVIRONMENT VARIABLES ---------- #
          env = [];

          # ---------- LAYOUTS ----------- #
          master = {
            mfact = 0.6;
          };

          # ---------- LOOK AND FEEL ---------- #
          general = {
            border_size = 2;

            gaps_in = 10;
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

              "blur, walker"
              "ignorealpha 0.4, walker"
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

          animations = {
            enabled = true;

            animation = [
              "workspaces, 1, 5, default, slidevert"
              "border, 1, 2, linear"
            ];
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
            "$prefix SHIFT, T, exec, $themeSwitcher"
            "$prefix SHIFT, W, exec, $wallpaperSwitcher"
            "$prefix, E, exec, $fileManager"

            "$prefix, Q, killactive,"
            "$prefix SHIFT, Q, exit,"

            "$prefix, V, togglefloating,"
            "$prefix, F, fullscreen, 1"
            "$prefix SHIFT, F, fullscreen, 0"

            # Utils
            "$prefix SHIFT, L, exec, loginctl lock-session"
            "$prefix SHIFT, S, exec, screenshot"

            # Layouts
            "$prefix, M, layoutmsg, swapwithmaster master"

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
        }; };
    }.${cfg.style} // {
# PLUGINS
#      settings = ;
    };
  };
}
