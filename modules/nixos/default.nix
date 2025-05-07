{ pkgs, lib, ... }: {
  imports = [
    ./extra-options.nix
    ./boot-loader.nix

    ./hardware
    ./wm
  ];
}
