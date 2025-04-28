{ config, pkgs, lib, ... }: {
  options = {
    pipewire.enable = lib.mkEnableOption "Sound";
    pipewire.pulse.enable = lib.mkEnableOption "PulseAudio";
    pipewire.alsa.enable = lib.mkEnableOption "ALSA";
    pipewire.jack.enable = lib.mkEnableOption "JACK";
  };

  config = lib.mkIf config.pipewire.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      wireplumber.enable = true;

      pulse.enable = config.pipewire.pulse.enable;
      alsa = {
        enable = config.pipewire.alsa.enable;
        support32Bit = config.pipewire.alsa.enable;
      };
      jack.enable = config.pipewire.jack.enable;
    };
  };
}
