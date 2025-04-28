{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  system.architecture = "x86_64-linux";
  networking.hostName = "mixos";
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hyprland.enable = true;
  bluetooth.enable = true;
  hardware-acceleration.enable = true;
  pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # TEMPORARY --- will move to home-manager
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
#    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "/usr/share/sddm/themes/sddm-ilzayn-theme";
  };
  # END TEMPORARY

  # TEMPORARY --- will move to home-manager
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.fira-code
  ];
  # END TEMPORARY
  environment.systemPackages = with pkgs; [
    # TEMPORARY --- will move to home-manager
    wlogout
    wl-clipboard
    cliphist
    walker
    waybar
    hypridle
    firefox
    tree
    # END TEMPORARY

    home-manager
  ];


  networking.wireless.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";
}
