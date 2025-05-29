{ pkgs, lib, ... }: {
  imports = [
    ./extra-options.nix
    ./waybar.nix
    ./walker.nix
    ./mako.nix

    ./themes
    ./terminal
    ./hypr
  ];
}
