rec {
  background = gray.dark;
  light_background = gray.base;
  foreground = white.dark;
  dark_foreground = gray.light;
  accent = cyan.dim;
  error = red.dim;
  success = green.dim;
  inactive = gray.bright;

  starship = {
    "0" = red.base; "1" = yellow.base; "2" = green.base; "3" = blue.base; "4" = magenta.base;
  };

  base00 = black.dim;
  base08 = gray.base;
  base01 = red.base;
  base09 = red.bright;
  base02 = green.base;
  base0A = green.bright;
  base03 = yellow.base;
  base0B = yellow.bright;
  base04 = blue.base;
  base0C = blue.bright;
  base05 = magenta.base;
  base0D = magenta.bright;
  base06 = cyan.base;
  base0E = cyan.bright;
  base07 = white.dim;
  base0F = white.base;

  # COLORS #
  black = {
    dim = "#191D24";
    base = "#1E222A";
    bright = "#222630";
  };
  gray = {
    dark = "#242933";
    dim = "#2E3440";
    base = "#3B4252";
    light = "#434C5E";
    bright = "#4C566A";
  };
  white = {
    dark = "#C0C8D8";
    dim = "#D8DEE9";
    base = "#E5E9F0";
    light = "#ECEFF4";
  };
  blue = {
    dim = "#5E81AC";
    base = "#81A1C1";
    bright = "#88C0D0";
  };
  cyan = {
    dim = "#80B3B2";
    base = "#8FBCBB";
    bright = "#9FC6C5";
  };
  red = {
    dim = "#B74E58";
    base = "#BF616A";
    bright = "#D06F79";
  };
  orange = {
    dim = "#CB775D";
    base = "#D08770";
    bright = "#D79784";
  };
  yellow = {
    dim = "#E7C173";
    base = "#EBCB8B";
    bright = "#F0D399";
  };
  green = {
    dim = "#97B67C";
    base = "#A3BE8C";
    bright = "#B1C89D";
  };
  magenta = {
    dim = "#A97EA1";
    base = "#B48EAD";
    bright = "#BE9DB8";
  };
}
