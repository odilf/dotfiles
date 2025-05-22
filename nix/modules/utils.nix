{
  config,
  lib,
  pkgs,
}:
rec {
  /**
    List of declared users in the system
  */
  users = builtins.attrNames config.custom.bundles;

  /**
    For each declared user,

    # Example

    ```nix
    mapUsers (username: { programs.fish.enable = true })
    =>
    { "odilf".programs.fish.enable = true; "study".programs.fish.enable = true }
    ```
  */
  mapUsers =
    f:
    (lib.foldl' lib.attrsets.unionOfDisjoint { } (
      builtins.map (username: { "${username}" = f username; }) users
    ));

  importModule =
    modulePath:
    import modulePath {
      inherit
        lib
        pkgs
        config
        ;
    };

  importModules = map importModule;

  checkAttrs =
    knownAttrs: modules:
    let
      resolved = lib.mergeAttrsList modules;
    in
    lib.attrsets.mapAttrsToList (
      attr: value:
      lib.mkIf (!builtins.elem attr knownAttrs)
        "Uknown attribute: `${attr}` (set to `${lib.generators.toPretty { } value}`)"
    ) resolved;

  /**
    Gets the `attr` of each of the modules, and merges them together
  */
  globalCfg = modules: attr: globalCfgExcept modules attr "";

  /**
    Gets the `attr` of each of the modules, removes the `exceptAttr` from that set,
    and merges them together. Useful to exclude `users.*` type stuff.
  */
  globalCfgExcept =
    modules: attr: exceptAttr:
    lib.foldl lib.recursiveUpdate { } (
      map (module: builtins.removeAttrs (lib.attrByPath [ attr ] { } module) [ exceptAttr ]) modules
    );

  /**
    Gets the attr at `attrPath` for each module, and generates a per-users config, the way
    `mapUsers` does.
  */
  perUserCfg =
    modules: attrPath:
    lib.foldl lib.recursiveUpdate { } (
      map (
        module:
        let
          originalAttr = lib.attrByPath attrPath { } module;
          attrFn = if builtins.isFunction originalAttr then originalAttr else _: originalAttr;
        in
        mapUsers attrFn
      ) modules
    );

  /**
    Adds the `globalAttr` for each module as-is, except that it removes the
    `userAttrPath` tree, and puts in its place `userAttrPath` for each user.
  */
  globalAndPerUserCfg =
    modules: globalAttr: userAttrPath:
    let
      perUserCfg' = perUserCfg modules;
      globalCfgExcept' = globalCfgExcept modules;

      # The `users` in `home-manager.users.*` or `users.users.*`
      userAttrDistinct = lib.elemAt userAttrPath 1;
    in
    (lib.mkMerge [
      (globalCfgExcept' globalAttr userAttrDistinct)
      { "${userAttrDistinct}" = perUserCfg' userAttrPath; }
    ]);
}
