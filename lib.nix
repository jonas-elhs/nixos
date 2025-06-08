{
  hosts,
  usersDir, userFile,
  hostsDir, hostFile,
  scriptsDir, scriptFile,
  packagesFile, packagesDir,
  themesFile, themesDir,
  nixpkgs,
  ...
}: let
  lib = nixpkgs.lib;
in rec {
  # Utils
  getSystemPkgs = (host: nixpkgs.legacyPackages.${hosts.${host}.system});
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

  # Packages
  getPackages = (system:
                 lib.forEach
                   (getDirNames packagesDir)
                   (package: (import (packagesFile package)))
               );

  # Themes
  getThemeSpecialisations = host: user: builtins.listToAttrs (lib.forEach
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
}
