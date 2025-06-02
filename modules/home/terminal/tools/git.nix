{ config, pkgs, lib, ... }: let
  cfg = config.git;
  colors = config.theme.colors;
  layout = config.layout;
in {
  options.git = {
    enable = lib.mkEnableOption "Git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
    };
  };
}
