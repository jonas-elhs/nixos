{ config, lib, pkgs, ... }: {
  hyprland.enable = true;
  bluetooth.enable = true;
  hardware-acceleration.enable = true;
  pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };
  home-manager.enable = true;

  boot-loader = {
    systemd-boot.enable = true;
    timeout = 10;
    extraConfig = ''
      auto-entries no
    '';
    extraEntries = [
      {
        name = "windows11";
        title = "Windows 11";
        efi = "/EFI/Microsoft/boot/bootmgfw.efi";
        sortKey = "a_windows";
      }
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;

  # TEMPORARY --- will move to nixos-modules
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
# Core Dumping
#    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "/usr/share/sddm/themes/sddm-ilzayn-theme";
  };
  # END TEMPORARY

  # TEMPORARY --- will move to nixos-modules
  networking.wireless.enable = true;
  # END TEMPORARY

  # TEMPORARY --- will move to nixos-modules
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  # END TEMPORARY

  environment.systemPackages = with pkgs; [
    # TEMPORARY --- will move to home-manager
    wl-clipboard
    cliphist

    firefox

    tree
    # END TEMPORARY

    # MAIL
    thunderbird
    mailspring # wayland problem?
    bluemail
    # END MAIL

    # FILES
#    xfce.thunar
    kdePackages.dolphin
#    pcmanfm

    yazi
    # END FILES

    (python3.withPackages (python-pkgs: with python-pkgs; [
      image-go-nord
    ]))
  ];

  system.architecture = "x86_64-linux";
  system.stateVersion = "24.11";
}
