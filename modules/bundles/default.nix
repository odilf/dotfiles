{
  lib,
  ...
}:
let
  bundles = {
    development = {
      desc = "Development & cli tools.";
      path = ./development.nix;
    };
    productivity = {
      desc = "Getting 'work' done with other humans.";
      path = ./productivity.nix;
    };
  };
in
{
  imports = map (bundle: bundle.path) (builtins.attrValues bundles) ++ [ ./desktop-environment.nix ];

  options.custom.bundles = lib.mkOption {
    default = { };
    description = "Opinionated bundles of software, and their configuration.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = lib.mapAttrs (
          name:
          { desc, ... }:
          {
            enable = lib.mkEnableOption desc;
          }
        ) bundles;
      }
    );
  };
}
