{ pkgs, lib, ... }: {
  imports = [
    ./extra-options.nix
    ./waybar.nix
    ./walker.nix

    ./themes
    ./terminal
    ./hypr
  ];
}
