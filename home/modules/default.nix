{ pkgs, lib, ... }: {
  imports = [
    ./extra-options.nix
    ./waybar.nix

    ./color
    ./terminal
    ./hypr
  ];
}
