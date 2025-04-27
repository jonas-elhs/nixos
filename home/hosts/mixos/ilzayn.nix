{ config, pkgs, ... }: {
  home.username = "ilzayn";
  home.homeDirectory = "/home/ilzayn";
  home.groups = [ "wheel" "input" ];

  home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/waybar;

  home.file.".config/hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/hypr/hypridle.conf;
  home.file.".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/hypr/hyprland.conf;
  home.file.".config/hypr/hyprpaper.conf".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/hypr/hyprpaper.conf;

  home.file.".config/walker".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/walker;

  home.file.".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/wlogout;

  services.hyprpaper.enable = true;

  hyprlock.enable = true;

  kitty.enable = true;
  starship.enable = true;
  fish.enable = true;
  git.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
