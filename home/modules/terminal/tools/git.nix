{ config, pkgs, lib, ... }: {
  options = {
    git.enable = lib.mkEnableOption "Enables Git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = false;
    };
  };
}
