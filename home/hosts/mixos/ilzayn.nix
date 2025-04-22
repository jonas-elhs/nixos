{ config, pkgs, ... }: {
  home.username = "ilzayn";
  home.homeDirectory = "/home/ilzayn";
  home.groups = [ "wheel" "input" ];

  home.file.".config/waybar".source = "/home/ilzayn/nixos/dotfiles/waybar";
  home.file.".config/hypr".source = "/home/ilzayn/nixos/dotfiles/hypr";

  kitty.enable = true;
  starship.enable = true;
  fish.enable = true;
  git.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
