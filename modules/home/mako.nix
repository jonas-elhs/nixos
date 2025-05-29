{ config, pkgs, lib, ... }: let
  cfg = config.mako;
  colors = config.theme.colors;
in {
  options.mako = {
    enable = lib.mkEnableOption "Mako";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Mako";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
    } // {
      default = let
        background = colors.background.base;
        text = colors.foreground.base;
        accent = colors.accent;

        font = "Maple Mono NF";
        font-size = "10";
        title-size = "12";
        border-size = 2;
        border-radius = 10;
      in {
        settings = {
          sort = "-time";
      
          actions = 1;
          markup = 1;
          format = "<span font='${title-size}' weight='bold'>%s</span>\\n%b";
          text-alignment = "left";

          default-timeout = 10000;
          ignore-timeout = 1;

          history = 1;
          max-history = 5;
          max-visible = 5;

          layer = "top";
          anchor = "top-right";

          on-button-left = "invoke-default-action";
          on-button-middle = "dismiss-all";
          on-button-right = "dismiss";

          font = "${font} ${font-size}";
          background-color = "${background}08";
          text-color = text;
          progress-color = "source ${accent}";

          border-size = border-size;
          border-radius = border-radius;
          border-color = accent;

          width = 300;
          height = 500;

          margin = 10;
          padding = 5;

          icons = 1;
          max-icon-size = 64;
          icon-path = "";
          icon-location = "left";
          icon-border-radius = 0;
        };
      };
    }.${cfg.style};
  };
}
