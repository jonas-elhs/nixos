{ hosts, usersDir, hostsDir, hostFile, scriptsDir, scriptFile, nixpkgs, ... }: let
  lib = nixpkgs.lib;
in rec {
  # Utils
  getPkgs = (host: nixpkgs.legacyPackages.${hosts.${host}.system});
  getDirNames = (dir: builtins.attrNames (builtins.readDir dir));
  getModuleConfig = (modulePath: (import modulePath) { config = null; lib = null; pkgs = null; });
  listPaths = (dir:
                lib.flatten (
                  lib.forEach
                    (getDirNames dir)
                    (name:
                      if lib.hasPrefix "_" name then []
                      else if lib.hasSuffix ".nix" name then /${dir}/${name}
                      else (listPaths /${dir}/${name})
                    )
                )
              );

  # Read Hosts and Users
  getUsersFromHost = (host:
                       lib.flatten (
                         lib.forEach
                           (getDirNames (usersDir host))
                           (userFile: lib.take 1 (lib.splitString "." userFile))
                       )
                     );
  getHosts = builtins.listToAttrs
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

  # NixOS
  getHostNames = builtins.attrNames hosts;
  forEachHost = (f: nixpkgs.lib.genAttrs getHostNames f);

  # Home Manager
  forEachUserInHost = (host: f:
                        lib.forEach
                          hosts.${host}.users
                          (user: {
                            name = "${user}@${host}";
                            value = (f user);
                          })
                      );
  forEachHome = (f:
                  builtins.listToAttrs (
                    lib.flatten (lib.mapAttrsToList
                      (forEachUserInHost)
                      (forEachHost f)
                    )
                  )
                );

  # Scripts
  getScripts = (system:
                 lib.forEach
                   (getDirNames scriptsDir)
                   (script: (import (scriptFile script) { pkgs = import nixpkgs { inherit system; }; }))
               );
}
