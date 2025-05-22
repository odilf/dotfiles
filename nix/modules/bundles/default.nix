{
  lib,
  config,
  pkgs,
  ...
}:
let
  utils = import ../utils.nix { inherit config lib pkgs; };

  # TODO: Move this to each bundle module?
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

  knownAttrs = [
    "users"
    "home-manager"
    "programs"
    "homebrew"
  ];

  modules = mapAttrsToList (name: bundle: utils.importModule bundle.path) bundles;

  inherit (lib.attrsets)
    mapAttrs
    mapAttrsToList
    hasAttr
    ;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  # perUserCfg =
  #   modules: attrPath:
  #   lib.mkMerge (
  #     map (
  #       module:
  #       utils.mapUsers (
  #         user:
  #         lib.mkIf config.custom.bundles."${user}".development.enable (lib.attrByPath attrPath { } module)
  #       )
  #     ) modules
  #   );

  # globalCfgExcept =
  #   modules: attr: exceptAttr:
  #   lib.mkMerge (
  #     map (module: builtins.removeAttrs (lib.attrByPath [ attr ] { } module) [ exceptAttr ]) modules
  #   );

  # globalAndPerUserCfg' =
  #   modules: globalAttr: userAttrPath:
  #   let
  #     perUserCfg' = perUserCfg modules;
  #     globalCfgExcept' = globalCfgExcept modules;

  #     # The `users` in `home-manager.users.*` or `users.users.*`
  #     userAttrDistinct = lib.elemAt userAttrPath 1;
  #   in
  #   lib.mkMerge [
  #     (globalCfgExcept' globalAttr userAttrDistinct)
  #     { users = perUserCfg' userAttrPath; }
  #   ];

  globalCfg = utils.globalCfg modules;
  # globalAndPerUserCfg = globalAndPerUserCfg' modules { guard = user: config.custom.bundles."${user}".};
  globalAndPerUserCfg = utils.globalAndPerUserCfg modules;
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
    warnings =
      let
        users = builtins.attrNames config.users.users;
        inUsers = name: hasAttr name config.users.users;
        # TODO: This doesn't do anything because the configuration below adds the entries by itself...
        # I don't know if it's fixable.
        usersWarning = builtins.map (
          name: lib.mkIf (!inUsers name) "${name} is not declared in `users.users`"
        ) users;
        attrsWarning = utils.checkAttrs knownAttrs modules;
      in
      usersWarning ++ attrsWarning;

    users = globalAndPerUserCfg "users" [
      "users"
      "users"
      "*"
    ];

    home-manager = globalAndPerUserCfg "home-manager" [
      "home-manager"
      "users"
      "*"
    ];

    programs = globalCfg "programs";
    homebrew = lib.mkIf isDarwin (globalCfg "homebrew");
  };

}
