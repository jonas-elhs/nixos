{ pkgs, lib, ... }: {
  imports = [
    ./extra-options.nix

    ./hardware
    ./wm
  ];
}
