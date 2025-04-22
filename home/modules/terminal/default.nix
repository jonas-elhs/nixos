{ pkgs, lib, ... }: {
  imports = [
    ./kitty.nix
    ./starship.nix
    ./fish.nix

    ./tools
  ];
}
