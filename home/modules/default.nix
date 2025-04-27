{ pkgs, lib, ... }: {
  imports = [
    ./extra-options.nix

    ./color
    ./terminal
    ./hypr
  ];
}
