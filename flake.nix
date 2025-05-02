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
                             (getDirNames ./home/hosts/${host})
                             (userfile: lib.take 1 (lib.splitString "." userfile))
                         )
                       );
    hosts = builtins.listToAttrs
              (lib.forEach
                (getDirNames ./hosts)
                (host: {
                  name = host;
                  value = {
                    users = getUsersFromHost host;
                    system = (getModuleConfig ./hosts/${host}/configuration.nix).system.architecture;
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
                  (getDirNames ./modules/scripts)
                  (file-name: (import ./modules/scripts/${file-name} { pkgs = import nixpkgs { inherit system; }; }))
              );
  in {

    nixosConfigurations = forEachHost (host:
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs host; };
        modules = [

          ./hosts/${host}/configuration.nix
          ./modules

          ({ config, pkgs, lib, ... }: builtins.listToAttrs (
            lib.forEach hosts.${host}.users (user: {
              name = "users";
              value = {
                users.${user} = {
                  isNormalUser = true;
                  extraGroups = (import ./home/hosts/${host}/${user}.nix { config = null; pkgs = null; }).home.groups;
                  initialPassword = user;
                };
              };
            })
          ))

          ({ ... }: {
            environment.systemPackages = scripts hosts.${host}.system;
          })

        ];
      }
    );

    homeConfigurations = getHomeConfigurations (host: user:
      home-manager.lib.homeManagerConfiguration {
        pkgs = getPkgs host;
        modules = [
          ./home/hosts/${host}/${user}.nix
          ./home/modules
        ];
        extraSpecialArgs = { inherit inputs; };
      }
    );

  };
}
