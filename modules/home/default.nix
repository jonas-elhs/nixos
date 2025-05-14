{ pkgs, lib, ... }: {
  imports = [
    ./extra-options.nix
    ./waybar.nix

    ./terminal
    ./hypr
  ];
}
