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
    paths = rec {
      hostsDir =                 ./hosts;
      hostFile = host:           hostsDir + /${host}/configuration.nix;
      hardwareFile = host:       hostsDir + /${host}/hardware-configuration.nix;

      usersDir = host:           ./hosts/${host}/users;
      userFile = host: user:     (usersDir host) + /${user}.nix;

      nixosModulesDir =          ./modules/nixos;
      homeModulesDir =           ./modules/home;

      scriptsDir =               ./modules/scripts;
      scriptFile = script:       scriptsDir + /${script};

      packagesDir =              ./packages;
      packagesFile = package:     packagesDir + /${package};

      themesDir =                ./modules/themes;
      themesFile = theme:        themesDir + /${theme}.nix;
    };

    # Lib
    lib = nixpkgs.lib;
    libx = (import ./lib.nix) { inherit hosts paths nixpkgs; };
    hosts = libx.getHosts;
  in {

    nixosConfigurations = libx.forEachHost (host:
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs host; };
        modules = lib.flatten [

          (paths.hostFile host)
          (libx.listPaths paths.nixosModulesDir)

          # Users
          ({ config, pkgs, lib, ... }: builtins.listToAttrs (
            lib.forEach hosts.${host}.users (user: {
              name = "users";
              value = {
                users.${user} = {
                  isNormalUser = true;
                  extraGroups = (import (paths.userFile host user) { config = null; pkgs = null; }).home.groups;
                  initialPassword = user;
                };
              };
            })
          ))

          ({ ... }: {
            # Hardware Configuration
            imports = [
              (paths.hardwareFile host)
            ];

            # Required Experimental Features
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            
            # Hostname
            networking.hostName = host;

            # Scripts
            environment.systemPackages = (libx.getScripts (libx.getSystem host));

            # Packages
            nixpkgs.overlays = [
              (final: prev: libx.getPackages (libx.getSystem host))
            ];

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
        pkgs = libx.getSystemPkgs host;
        extraSpecialArgs = { inherit inputs; };
        modules = lib.flatten [

          (paths.userFile host user)
          (libx.listPaths paths.homeModulesDir)

          inputs.walker.homeManagerModules.default
          inputs.zen-browser.homeModules.twilight
          inputs.nvf.homeManagerModules.default

          ({ config, ... }: {
            # Themes
            specialisation = libx.getThemeSpecialisations host user;

            # Options
            home.homeDirectory = "/home/${config.home.username}";
            programs.home-manager.enable = true;
            home.stateVersion = (libx.getModuleConfig (paths.hostFile host)).system.stateVersion;

            # Packages
            nixpkgs.overlays = [
              (final: prev: libx.getPackages (libx.getSystem host))
            ];
          })

        ];
      }
    );

  };
}
