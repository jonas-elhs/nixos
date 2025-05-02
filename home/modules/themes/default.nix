{ config, pkgs, lib, ... }: let
  themes = builtins.listToAttrs (
             lib.forEach
               (builtins.attrNames (builtins.readDir ./.))
               (userfile: {
                 name = builtins.toString (lib.take 1 (lib.splitString "." userfile));
                 value = import ./${userfile};
               })
             );
in {
  options = {
    theme.name = lib.mkOption {
      type = lib.types.str;
      default = "nordic";
      description = "The name of the theme";
    };

    theme.colors = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "The colors of the theme";
    };
  };

  config = {
    theme.colors = import ./${config.theme.name}.nix;
  };
}
