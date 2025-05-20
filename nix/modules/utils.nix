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
    f: (lib.attrsets.mergeAttrsList (builtins.map (username: { "${username}" = f username; }) users));

  importModule =
    path:
    import path {
      inherit
        lib
        pkgs
        config
        ;
    };

  importModules = modules: lib.foldl lib.recursiveUpdate { } (map importModule modules);
  checkAttrs =
    knownAttrs: resolved:
    lib.attrsets.mapAttrsToList (
      attr: value:
      lib.mkIf (!builtins.elem attr knownAttrs)
        "Uknown attribute: `${attr}` (set to `${lib.generators.toPretty { } value}`)"
    ) resolved;

  perUserCfg = resolved: attrPath: mapUsers (username: lib.attrByPath attrPath { } resolved);
}
