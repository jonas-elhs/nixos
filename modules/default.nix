{ pkgs, lib, ... }: let
  scripts = lib.forEach (builtins.attrNames (builtins.readDir ./scripts)) (file-name: "./${file-name}");
in {
  imports = scripts ++ [
    ./extra-options.nix
  ];
}
