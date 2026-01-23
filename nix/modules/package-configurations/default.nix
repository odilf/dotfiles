{
  lib,
  pkgs,
  config,
  ...
}:
let
  utils = import ../utils.nix { inherit lib pkgs config; };
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
    ./iamb.nix
    ./jujutsu.nix
    ./khal.nix
    ./niri.nix
    ./nix.nix
    ./noctalia.nix
    ./ssh.nix
    ./taskwarrior.nix
    ./zathura.nix
  ];

  knownAttrs = [
    "home-manager"
    "users"

    "system"
    "programs"
    "services"
    "systemd"
    "hardware"
    "networking"
    "nix"
    "environment"
    "fonts"
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

    system = globalCfg "system";
    programs = globalCfg "programs";
    services = globalCfg "services";
    systemd = globalCfg "systemd";
    hardware = globalCfg "hardware";
    networking = globalCfg "networking";
    nix = globalCfg "nix";
    environment = globalCfg "environment";
    fonts = globalCfg "fonts";
    age = globalCfg "age";
  };
}
