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
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs: let
    # ----------- PATHS ---------- #
    hostsDir =                 ./hosts;
    hostFile = host:           hostsDir + /${host}/configuration.nix;

    usersDir = host:           ./hosts/${host}/users;
    userFile = host: user:     (usersDir host) + /${user}.nix;

    nixosModulesDir =          ./modules/nixos;
    nixosModulesFile =         nixosModulesDir;

    homeModulesDir =           ./modules/home;
    homeModulesFile =          homeModulesDir;

    scriptsDir =               ./modules/scripts;
    scriptFile = script:       scriptsDir + /${script};

    themesDir =                homeModulesDir + /themes;
    themesFile = theme:        themesDir + /${theme}.nix;

    # ---------- UTILS ---------- #
    lib = nixpkgs.lib;

    getPkgs = (host: nixpkgs.legacyPackages.${hosts.${host}.system});
    getDirNames = (dir: builtins.attrNames (builtins.readDir dir));
    getModuleConfig = (modulePath: (import modulePath) { config = null; lib = null; pkgs = null; });

    # ---------- READ HOSTS AND USERS FROM FILE SYSTEM ---------- #

    # hosts = {
    #   <host name> = {
    #     users = [
    #       "<user1>"
    #       "<user2>"
    #     ];
    #     system = "<system architecture>";
    #   };
    # };

    getUsersFromHost = (host:
                         lib.flatten (
                           lib.forEach
                             (getDirNames (usersDir host))
                             (userFile: lib.take 1 (lib.splitString "." userFile))
                         )
                       );
    hosts = builtins.listToAttrs
              (lib.forEach
                (getDirNames hostsDir)
                (host: {
                  name = host;
                  value = {
                    users = getUsersFromHost host;
                    system = (getModuleConfig (hostFile host)).system.architecture;
                  };
                })
              );

    hostNames = builtins.attrNames hosts;
    forEachHost = (f: nixpkgs.lib.genAttrs hostNames f);

    # ---------- HOME MANAGER ---------- #
    # Host name and function to every user in that host mapped to their configuration | [{ name = "user1@host1"; value = configuration; } { name = "user2@host1"; value = configuration; }]
    getUserConfigurationsInHost = (host: f:
                                    lib.forEach
                                      hosts.${host}.users
                                      (user: {
                                        name = "${user}@${host}";
                                        value = (f user);
                                      })
                                  );
    # Function to every user in every host mapped to their configuration | [{ name = "user1@host1"; value = configuration; } { ... } { name = "user1@host2"; value = configuration }]
    getUserConfigurationsInEveryHost = (f:
                                         lib.flatten (lib.mapAttrsToList
                                           (getUserConfigurationsInHost)
                                           (forEachHost f)
                                         )
                                       );
    # Function to every user in every host mapped to their configuration | { "user1@host1" = configuration "..." = ... "user1@host2" = configuration }
    getHomeConfigurations = (f: builtins.listToAttrs (getUserConfigurationsInEveryHost f));

    # ---------- SCRIPTS ---------- #
    scripts = (system:
                lib.forEach
                  (getDirNames scriptsDir)
                  (script: (import (scriptFile script) { pkgs = import nixpkgs { inherit system; }; }))
              );
  in {

    nixosConfigurations = forEachHost (host:
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs host; };
        modules = [

          (hostFile host)
          nixosModulesFile

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
            environment.systemPackages = (scripts hosts.${host}.system);
          })

          ({ ... }: {
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

    homeConfigurations = getHomeConfigurations (host: user:
      home-manager.lib.homeManagerConfiguration {
        pkgs = getPkgs host;
        extraSpecialArgs = { inherit inputs; };
        modules = [

          (userFile host user)
          homeModulesFile

          inputs.walker.homeManagerModules.default
          inputs.zen-browser.homeModules.twilight
          inputs.nvf.homeManagerModules.default

          ({ ... }: {
            specialisation = builtins.listToAttrs (lib.forEach
#              (lib.remove "default.nix" (builtins.attrNames (builtins.readDir themesDir)))
              (if ((getModuleConfig (userFile host user)).theme.themes) == "all" then (lib.remove "default.nix" (builtins.attrNames (builtins.readDir themesDir))) else ((getModuleConfig (userFile host user)).theme.themes))
              (file: let theme-name = builtins.toString (lib.take 1 (lib.splitString "." file)); in {
                name = "theme-${theme-name}";
                value = {
                  configuration = {
                    theme.colors = import (themesFile theme-name);
                  };
                };
              })
            );
          })
        ];
      }
    );

  };
}
