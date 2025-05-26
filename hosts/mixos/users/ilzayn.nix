{ config, pkgs, ... }: {
  home.username = "ilzayn";
  home.homeDirectory = "/home/ilzayn";
  home.groups = [ "wheel" "input" ];

  programs.zen-browser.enable = true;
  home.file.".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/wlogout;

  theme.name = "nordic";
  theme.themes = "all";

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

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
