{
  lib,
  pkgs,
  config,
  ...
}:
let
  utils = import ../utils.nix { inherit config lib pkgs; };
  modules = map utils.importModule [
    ./aerospace.nix
    ./alacritty.nix
    ./bat.nix
    ./cargo.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./helix.nix
    ./home-manager.nix
    ./jujutsu.nix
  ];

  knownAttrs = [
    "home-manager"
    "users"
    "fonts"
    "environment"
    "system"
  ];

  globalCfg = utils.globalCfg modules;
  globalAndPerUserCfg = utils.globalAndPerUserCfg modules;
in
{
  config = {
    warnings = utils.checkAttrs knownAttrs modules;

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

    fonts = globalCfg "fonts";
    environment = globalCfg "environment";
    system = globalCfg "system";
  };
}
