{ config, pkgs, lib, ... }: {
  theme.themes = {
    nordic = rec {
      background = gray.dark;
      light_background = gray.base;
      foreground = white.dark;
      dark_foreground = gray.light;
      accent = yellow.dim;

      starship = {
        "0" = red.base; "1" = yellow.base; "2" = green.base; "3" = blue.base; "4" = magenta.base;
      };

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
        dark = "#BBC3D4";
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
        bright = "#C5727A";
      };
      orange = {
        dim = "#CB775D";
        base = "#D08770";
        bright = "#D79784";
      };
      yellow = {
        dim = "#E7C173";
        base = "#EBCB8B";
        bright = "#EFD49F";
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
    };
  };
}
