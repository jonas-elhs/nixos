{ pkgs, lib, ... }: {
  imports = [
    ./bluetooth.nix
    ./pipewire.nix
    ./hardware-acceleration.nix
  ];
}
