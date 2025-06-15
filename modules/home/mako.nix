{ config, pkgs, lib, ... }: let
  cfg = config.mako;
  colors = config.theme.colors;
  layout = config.theme.layout;
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
      in {
        settings = {
          sort = "-time";
      
          actions = 1;
          markup = 1;
          format = "<span font='${layout.font.size}' weight='bold'>%s</span>\\n%b";
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

          font = "${layout.font.name} ${layout.font.sub}";
          background-color = background + layout.background.opacity_hex;
          text-color = text;
          progress-color = "source ${accent}";

          border-size = layout.border.width;
          border-radius = layout.border.radius.size;
          border-color = accent;

          width = 300;
          height = 500;

          margin = layout.gap.inner;
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
