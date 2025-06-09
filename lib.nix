{ hosts, paths, nixpkgs, ... }: let
  lib = nixpkgs.lib;
in rec {
  # Utils
  getSystem = (host: hosts.${host}.system);
  getSystemPkgs = (host: nixpkgs.legacyPackages.${getSystem host});
  getDirNames = (dir: builtins.filter
    (file: !(lib.hasPrefix "_" file) && !(lib.hasPrefix "." file))
    (builtins.attrNames (builtins.readDir dir))
  );
  getModuleConfig = (modulePath: (import modulePath) { config = null; lib = null; pkgs = null; libx = null; });
  isHomeManagerEnabled = (host: (getModuleConfig (paths.hostFile host)).home-manager.enable == true);
  listPaths = (dir:
    lib.flatten (
      lib.forEach
      (getDirNames dir)
      (name:
        if lib.hasSuffix ".nix" name then /${dir}/${name}
        else (listPaths /${dir}/${name})
      )
    )
  );

  # Read Hosts and Users
  _getUsersFromHost = (host:
    lib.flatten (
      lib.forEach
      (getDirNames (paths.usersDir host))
      (userFile: lib.take 1 (lib.splitString "." userFile))
    )
  );
  getHosts = builtins.listToAttrs (lib.forEach
    (getDirNames paths.hostsDir)
    (host: {
      name = host;
      value = {
        users = _getUsersFromHost host;
        system = (getModuleConfig (paths.hostFile host)).system.architecture;
      };
    })
  );

  # NixOS
  getHostNames = builtins.attrNames hosts;
  forEachHost = (f: nixpkgs.lib.genAttrs getHostNames f);

  # Home Manager
  _forEachUserInHost = (host: f:
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
        (_forEachUserInHost)
        (lib.filterAttrs (name: value: isHomeManagerEnabled name) (forEachHost f))
      )
    )
  );

  # Scripts
  getScripts = (system: lib.forEach
    (getDirNames paths.scriptsDir)
    (script: (import (paths.scriptFile script) { pkgs = import nixpkgs { inherit system; }; }))
  );

  # Packages
  getPackages = (system: builtins.listToAttrs
    (lib.forEach
      (getDirNames paths.packagesDir)
      (package: { name = package; value = (import (paths.packagesFile package)); })
    )
  );

  # Themes
  _useAllThemes = (host: user:
    ((getModuleConfig (paths.userFile host user)).theme.themes) == "all"
  );
  _getAllThemes = (lib.remove "default.nix" (builtins.attrNames (builtins.readDir paths.themesDir)));
  _getSpecifiedThemes = (host: user: ((getModuleConfig (paths.userFile host user)).theme.themes));
  _getThemeNames = (host: user:
    if (_useAllThemes host user) then _getAllThemes
    else _getSpecifiedThemes host user
  );
  getThemeSpecialisations = host: user: builtins.listToAttrs (lib.forEach
      (_getThemeNames host user)
      (file: let theme-name = builtins.toString (lib.take 1 (lib.splitString "." file)); in {
      name = "theme-${theme-name}";
      value = {
        configuration = {
          theme.colors = import (paths.themesFile theme-name);
        };
      };
    })
  );
}
