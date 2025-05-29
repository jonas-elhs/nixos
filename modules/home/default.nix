{ pkgs, lib, ... }: {
  imports = [
    ./extra-options.nix
    ./waybar.nix
    ./walker.nix
    ./mako.nix
    ./zen.nix

    ./themes
    ./terminal
    ./hypr
  ];
}
