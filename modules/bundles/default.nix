{
  lib,
  pkgs,
  ...
}:
let
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

  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  imports = map (bundle: bundle.path) (builtins.attrValues bundles);

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

  config.homebrew = lib.mkIf isDarwin {
    enable = true;
    # onActivation.cleanup = "uninstall";
  };
}
