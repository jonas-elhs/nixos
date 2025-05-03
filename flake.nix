{
  description = "Ilzayn NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs: let
    # ----------- PATHS ---------- #
    hostsDir =                 ./hosts;
    hostFile = host:           hostsDir + /${host}/configuration.nix;

    usersDir = host:           ./home/hosts/${host};
    userFile = host: user:     (usersDir host) + /${user}.nix;

    nixosModulesFile =          ./modules;
    homeModulesFile =           ./home/modules;

    scriptsDir =               ./modules/scripts;
    scriptFile = script:       scriptsDir + /${script};

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

        ];
      }
    );

    homeConfigurations = getHomeConfigurations (host: user:
      home-manager.lib.homeManagerConfiguration {
        pkgs = getPkgs host;
        modules = [
          (userFile host user)
          homeModulesFile
        ];
        extraSpecialArgs = { inherit inputs; };
      }
    );

  };
}
