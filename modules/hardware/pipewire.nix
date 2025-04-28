{ config, pkgs, lib, ... }: let
  cfg = config.pipewire;
in {
  options = {
    pipewire.enable = lib.mkEnableOption "Sound";
    pipewire.pulse.enable = lib.mkEnableOption "PulseAudio";
    pipewire.alsa.enable = lib.mkEnableOption "ALSA";
    pipewire.jack.enable = lib.mkEnableOption "JACK";
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      wireplumber.enable = true;

      pulse.enable = cfg.pulse.enable;
      alsa = {
        enable = cfg.alsa.enable;
        support32Bit = cfg.alsa.enable;
      };
      jack.enable = cfg.jack.enable;
    };
  };
}
