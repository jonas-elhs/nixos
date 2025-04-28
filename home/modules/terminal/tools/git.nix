{ config, pkgs, lib, ... }: {
  options = {
    git.enable = lib.mkEnableOption "Git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
    };
  };
}
