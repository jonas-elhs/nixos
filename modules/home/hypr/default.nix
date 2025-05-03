{ pkgs, lib, ... }: {
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];
}
