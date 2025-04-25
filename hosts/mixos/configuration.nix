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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    wlogout
    wl-clipboard
    cliphist
    walker
    hyprpaper
    waybar
    hyprlock

    git
    tree
    firefox


    home-manager
  ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mixos";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;

    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}
