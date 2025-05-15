{ pkgs, lib, ... }: {
  imports = [
    ./git.nix
    ./fastfetch.nix
  ];
}
