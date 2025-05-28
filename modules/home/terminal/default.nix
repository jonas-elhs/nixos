{ pkgs, lib, ... }: {
  imports = [
    ./kitty.nix
    ./starship.nix
    ./fish.nix
    ./neovim.nix

    ./tools
  ];
}
