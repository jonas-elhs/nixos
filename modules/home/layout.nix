{ config, pkgs, lib, ... }: {
  options.layout = {
    border.width = lib.mkOption {
      type = lib.types.str;
      default = "2";
      description = "The border width.";
    };
    border.radius = lib.mkOption {
      type = lib.types.str;
      default = "10";
      description = "The border radius.";
    };
    border.inner_radius = lib.mkOption {
      type = lib.types.str;
      default = config.layout.border.radius;
      description = "The border radius of inner elements.";
    };

    font.name = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "The main font.";
    };
    font.sub = lib.mkOption {
      type = lib.types.str;
      default = config.layout.font.size;
      description = "The sub font size.";
    };
    font.size = lib.mkOption {
      type = lib.types.str;
      default = "12";
      description = "The main font size.";
    };
    font.title = lib.mkOption {
      type = lib.types.int;
      default = config.layout.font.size;
      description = "The title font size.";
    };

    background.opacity = lib.mkOption {
      type = lib.types.float;
      default = 0.5;
      description = "The main background opacity.";
    };
    background.opacity_hex = lib.mkOption {
      type = lib.types.str;
      default = "80";
      description = "The main background opacity in hex.";
    };

    gap.size = lib.mkOption {
      type = lib.types.str;
      default = "10";
      description = "The main gap size between elements.";
    };
    gap.inner = lib.mkOption {
      type = lib.types.str;
      default = config.layout.gap.size;
      description = "The gap size between inner elements.";
    };
  };
}
