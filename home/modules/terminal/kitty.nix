{ config, pkgs, lib, ... }: {
  options = {
    kitty.enable = lib.mkEnableOption "Kitty Terminal";
    kitty.style = lib.mkOption {
      type = lib.types.str; 
      default = "transparent";
      description = "The style of Kitty Terminal";
    };
  };

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
    } // {
      transparent = {
        shellIntegration = {
          enableFishIntegration = true;
          mode = "no-rc no-cursor";
        };
        font = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font Mono";
          size = 12;
        };
        settings = {
          background_opacity = 0.5;
          window_padding_width = 8;
          background_blur = 0;
          cursor_trail = 1;
        };
      };
    }.${config.kitty.style};
  };
}
