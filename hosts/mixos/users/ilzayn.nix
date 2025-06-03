{ config, pkgs, ... }: {
  home.username = "ilzayn";
  home.homeDirectory = "/home/ilzayn";
  home.groups = [ "wheel" "input" ];

  # TEMPORARY -- will move to module
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    #font-awesome
    maple-mono.NF
  ];
  # END TEMPORARY

  theme.name = "nordic";
  theme.themes = "all";
  layout = {
    border = {
      width = "2";
      radius = {
        size = "10";
        inner = "7";
      };
    };
    font = {
      name = "Maple Mono NF";
      sub = "8";
      size = "12";
      title = "18";
    };
    background = {
      opacity = 0.5;
      opacity_hex = "80";
    };
    gap = {
      size = "20";
      inner = "10";
    };
    blur = {
      size = "5";
      passes = "2";
    };
  };

  hyprland = {
    enable = true;
    persistentWorkspaces = 5;
  };
  hyprlock.enable = true;
  hypridle.enable = true;
  hyprpaper = {
    enable = true;
    wallpaper = "~/wallpapers/moon.png";
  };
  waybar = {
    enable = true;
    gpu_hwmon = 5;
    style = "vertical";
  };
  kitty.enable = true;
  starship.enable = true;
  fish.enable = true;
  git.enable = true;
  fastfetch.enable = true;
  walker.enable = true;
  neovim.enable = true;
  mako.enable = true;
  zen.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
