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
        };
      };
    }.${cfg.style};
  };
}
