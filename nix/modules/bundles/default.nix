{
  lib,
  config,
  pkgs,
  ...
}:
let
  utils = import ../utils.nix { inherit config lib pkgs; };

  # TODO: Move this to each bundle module
  bundles = {
    development = {
      desc = "Development & cli tools.";
      path = ./development.nix;
    };
    creative = {
      desc = "Software for making music and art.";
      path = ./creative.nix;
    };
    games = {
      desc = "Videogames on the computer.";
      path = ./games.nix;
    };
    productivity = {
      desc = "Getting 'work' done with other humans.";
      path = ./productivity.nix;
    };
    social = {
      desc = "Chatting and socializing apps.";
      path = ./social.nix;
    };
  };

  modules = mapAttrsToList (name: bundle: bundle.path) bundles;

  knownAttrs = [
    "users"
    "home-manager"
    "programs"
    "homebrew"
  ];

  resolved = utils.importModules modules;

  inherit (lib.attrsets)
    mapAttrs
    mapAttrsToList
    hasAttr
    ;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  perUserCfg = utils.perUserCfg resolved;
in
{
  options.custom.bundles = lib.mkOption {
    default = { };
    description = "Opinionated bundles of software, and their configuration.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = mapAttrs (
          name:
          { desc, ... }:
          {
            enable = lib.mkEnableOption desc;
          }
        ) bundles;
      }
    );
  };

  config = {
    # TODO: This doesn't do anything because the configuration below adds the entries by itself...
    # I don't know if it's fixable.
    warnings =
      let
        users = builtins.attrNames config.custom.bundles;
        inUsers = name: hasAttr name config.users.users;
        usersWarning = builtins.map (
          name: lib.mkIf (!inUsers name) "${name} is not declared in `users.users`"
        ) users;
        attrsWarning = utils.checkAttrs knownAttrs resolved;
      in
      usersWarning ++ attrsWarning;

    users = (resolved.users or { }) // {
      users = perUserCfg [
        "users"
        "users"
        "*"
      ];
    };

    home-manager = (resolved.home-manager or { }) // {
      users = perUserCfg [
        "home-manager"
        "users"
        "*"
      ];
    };

    programs = resolved.programs or { };
    homebrew = lib.mkIf isDarwin (resolved.homebrew or { });
  };

}
