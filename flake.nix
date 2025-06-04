{
  description = "Ilzayn NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs: let
    # Paths
    hostsDir =                 ./hosts;
    hostFile = host:           hostsDir + /${host}/configuration.nix;

    usersDir = host:           ./hosts/${host}/users;
    userFile = host: user:     (usersDir host) + /${user}.nix;

    nixosModulesDir =          ./modules/nixos;
    homeModulesDir =           ./modules/home;

    scriptsDir =               ./modules/scripts;
    scriptFile = script:       scriptsDir + /${script};

    themesDir =                ./modules/themes;
    themesFile = theme:        themesDir + /${theme}.nix;

    # Lib
    lib = nixpkgs.lib;
    libx = (import ./lib.nix) { inherit hosts usersDir hostsDir hostFile scriptsDir scriptFile nixpkgs; };

    hosts = libx.getHosts;
    scripts = libx.getScripts;
  in {

    nixosConfigurations = libx.forEachHost (host:
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs host; };
        modules = lib.flatten [

          (hostFile host)
          (libx.listPaths nixosModulesDir)

          # Users
          ({ config, pkgs, lib, ... }: builtins.listToAttrs (
            lib.forEach hosts.${host}.users (user: {
              name = "users";
              value = {
                users.${user} = {
                  isNormalUser = true;
                  extraGroups = (import (userFile host user) { config = null; pkgs = null; }).home.groups;
                  initialPassword = user;
                };
              };
            })
          ))

          ({ ... }: {
            # Scripts
            environment.systemPackages = (scripts hosts.${host}.system);

            # Caches
            nix.settings = {
              trusted-users = [
                "root"
                "@wheel"
              ];
              substituters = [
                "https://walker-git.cachix.org"
              ];
              trusted-public-keys = [
                "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
              ];
            };
          })

        ];
      }
    );

    homeConfigurations = libx.forEachHome (host: user:
      home-manager.lib.homeManagerConfiguration {
        pkgs = libx.getPkgs host;
        extraSpecialArgs = { inherit inputs; };
        modules = lib.flatten [

          (userFile host user)
          (libx.listPaths homeModulesDir)

          inputs.walker.homeManagerModules.default
          inputs.zen-browser.homeModules.twilight
          inputs.nvf.homeManagerModules.default

          ({ config, ... }: {
            # Themes
            specialisation = builtins.listToAttrs (lib.forEach
              (if ((libx.getModuleConfig (userFile host user)).theme.themes) == "all" then (lib.remove "default.nix" (builtins.attrNames (builtins.readDir themesDir))) else ((libx.getModuleConfig (userFile host user)).theme.themes))
              (file: let theme-name = builtins.toString (lib.take 1 (lib.splitString "." file)); in {
                name = "theme-${theme-name}";
                value = {
                  configuration = {
                    theme.colors = import (themesFile theme-name);
                  };
                };
              })
            );

            # Options
            home.homeDirectory = "/home/${config.home.username}";
            programs.home-manager.enable = true;
            home.stateVersion = (libx.getModuleConfig (hostFile host)).system.stateVersion;
          })

        ];
      }
    );

  };
}
