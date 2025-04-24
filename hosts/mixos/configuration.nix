{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  system.architecture = "x86_64-linux";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fonts.packages = with pkgs; [
    font-awesome
  ];

  environment.systemPackages = with pkgs; [
    wlogout
    wl-clipboard
    cliphist
    walker

    home-manager
    waybar

    git
    tree
    firefox
  ];





  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mixos";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  #users.users.ilzayn = {
  #  isNormalUser = true;
  #  extraGroups = [ "wheel" ];
  #  initialPassword = "ilzayn";
  #};

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}

