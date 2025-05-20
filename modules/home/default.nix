{ pkgs, lib, ... }: {
  imports = [
    ./extra-options.nix
    ./waybar.nix

    ./themes
    ./terminal
    ./hypr
  ];
}
