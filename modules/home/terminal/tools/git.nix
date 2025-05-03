{ config, pkgs, lib, ... }: let
  cfg = config.git;
in {
  options = {
    git.enable = lib.mkEnableOption "Git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
    };
  };
}
