{ config, pkgs, lib, ... }: let
  layout = config.layout;
in {
  options.layout = {
    border.width = lib.mkOption {
      type = lib.types.str;
      default = "2";
      description = "The border width.";
    };
    border.radius.size = lib.mkOption {
      type = lib.types.str;
      default = "10";
      description = "The border radius.";
    };
    border.radius.inner = lib.mkOption {
      type = lib.types.str;
      default = layout.border.radius.size;
      description = "The border radius of inner elements.";
    };

    font.name = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "The main font.";
    };
    font.sub = lib.mkOption {
      type = lib.types.str;
      default = layout.font.size;
      description = "The sub font size.";
    };
    font.size = lib.mkOption {
      type = lib.types.str;
      default = "12";
      description = "The main font size.";
    };
    font.title = lib.mkOption {
      type = lib.types.int;
      default = layout.font.size;
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
      default = "20";
      description = "The main gap size between elements.";
    };
    gap.inner = lib.mkOption {
      type = lib.types.str;
      default = layout.gap.size;
      description = "The gap size between inner elements.";
    };

    blur.size = lib.mkOption {
      type = lib.types.str;
      default = "5";
      description = "The blur size.";
    };
    blur.passes = lib.mkOption {
      type = lib.types.str;
      default = "2";
      description = "The amount of blur passes to perform.";
    };
    blur.amount = lib.mkOption {
      type = lib.types.str;
      default = toString ((lib.toInt layout.blur.size) * (lib.toInt layout.blur.passes));
      description = "The blur amount in pixel.";
    };
  };
}
