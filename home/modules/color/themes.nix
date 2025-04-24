{ config, pkgs, lib, ... }: {
  theme.themes = {
    nordic = {
      # black
      base00 = "#191D24";
      base08 = "#3B4252";

      # red
      base01 = "#BF616A";
      base09 = "#D06F79";

      # green
      base02 = "#A3BE8C";
      base0A = "#B1D196";

      # yellow
      base03 = "#EBCB8B";
      base0B = "#F0D399";

      # blue
      base04 = "#81A1C1";
      base0C = "#88C0D0";

      # magenta
      base05 = "#B48EAD";
      base0D = "#C895BF";

      # cyan
      base06 = "#8FBCBB";
      base0E = "#93CCDC";

      # white
      base07 = "#D8DEE9";
      base0F = "#E5E9F0";
    }
  };
}
