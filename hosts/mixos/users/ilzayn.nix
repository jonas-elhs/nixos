{ config, pkgs, ... }: {
  home.username = "ilzayn";
  home.homeDirectory = "/home/ilzayn";
  home.groups = [ "wheel" "input" ];

  home.file.".config/hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/hypr/hypridle.conf;
  home.file.".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/wlogout;

  theme.name = "nordic";
  theme.themes = "all";

  hyprland = {
    enable = true;
    persistentWorkspaces = 5;
  };
  hyprlock.enable = true;
  hyprpaper = {
    enable = true;
    wallpaper = "~/wallpapers/moon.png";
  };
  waybar = {
    enable = true;
    gpu_hwmon = 5;
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
