{ config, pkgs, ... }: {
  home.username = "ilzayn";
  home.homeDirectory = "/home/ilzayn";
  home.groups = [ "wheel" "input" ];

  home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/waybar;
  home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/hypr;
  home.file.".config/walker".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/walker;
  home.file.".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink /home/ilzayn/nixos/dotfiles/wlogout;

  services.hyprpaper.enable = true;

  kitty.enable = true;
  starship.enable = true;
  fish.enable = true;
  git.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
