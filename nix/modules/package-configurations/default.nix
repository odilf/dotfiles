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
    ./niri.nix
    ./nix.nix
    ./ssh.nix
    ./taskwarrior.nix
  ];

  knownAttrs = [
    "home-manager"
    "users"
    "fonts"
    "environment"
    "system"
    "nix"
    "age"
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

    environment = globalCfg "environment";
    fonts = globalCfg "fonts";
    nix = globalCfg "nix";
    system = globalCfg "system";
    age = globalCfg "age";
  };
}
