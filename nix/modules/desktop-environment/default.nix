{
  pkgs,
  lib,
  config,
  ...
}:
let
  # cfg = config.desktop-environment;
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  imports = [
    ./linux
    ./darwin
  ];

  config = lib.mkIf config.gui {
    environment.systemPackages =
      [
        pkgs.todoist
        pkgs.qalculate-qt
      ]
      ++ lib.optionals isLinux [
        # pkgs.bitwarden-cli
        # pkgs.bitwarden-desktop
        # pkgs.todoist-electron
      ];

    homebrew.casks = lib.mkIf isDarwin [
      "bitwarden"
      "todoist"
    ];
  };
}
