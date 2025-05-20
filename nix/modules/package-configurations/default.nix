{
  lib,
  pkgs,
  config,
  ...
}:
let
  utils = import ../utils.nix { inherit config lib pkgs; };
  modules = [
    ./aerospace.nix
    ./alacritty.nix
    ./bat.nix
    ./cargo.nix
    ./fish.nix
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

  resolved = utils.importModules modules;

  perUserCfg = utils.perUserCfg resolved;
in
{
  config = {
    warnings = utils.checkAttrs knownAttrs resolved;

    home-manager = (resolved.home-manager or { }) // {
      users = perUserCfg [
        "home-manager"
        "users"
        "*"
      ];
    };

    users.users = perUserCfg [
      "users"
      "users"
      "*"
    ];

    fonts = resolved.fonts or { };
    environment = resolved.environment or { };
    system = resolved.system or { };
  };
}
