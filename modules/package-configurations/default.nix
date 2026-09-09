{
  lib,
  pkgs,
  config,
  ...
}:
let
  utils = import ../utils.nix { inherit lib pkgs config; };
  modules = map utils.importModule [
    ./accounts.nix
    ./aerospace.nix
    ./alacritty.nix
    ./bat.nix
    ./cargo.nix
    ./cmus.nix
    ./dump-thought.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./karabiner.nix
    ./helix.nix
    ./home-manager.nix
    ./iamb.nix
    ./jujutsu.nix
    ./kanata.nix
    ./mvp.nix
    ./musicbrainz-picard.nix
    ./nh.nix
    ./niri.nix
    ./niri-session-manager.nix
    ./nix.nix
    ./noctalia.nix
    ./osx-scrobbler.nix
    # ./reaper.nix
    ./rofi.nix
    ./sioyek.nix
    ./ssh.nix
    ./taskwarrior.nix
    ./theme-switch.nix
    ./tofi.nix
    ./wezterm.nix
    ./yazi.nix
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
    "nixpkgs"
    "environment"
    "fonts"
    "age"
    "custom"
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
    nixpkgs = globalCfg "nixpkgs";
    environment = globalCfg "environment";
    fonts = globalCfg "fonts";
    age = globalCfg "age";
    custom = globalCfg "custom";
  };
}
