{
  pkgs,
  lib,
  ...
}:
let
  # cfg = config.desktop-environment;
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  imports = [
    ./linux.nix
    ./darwin.nix
  ];

  options.desktop-environment = {
    enable = lib.mkEnableOption "Desktop environment";
  };

  config = {
    environment.systemPackages =
      [
        pkgs.todoist
        pkgs.qalculate-qt
      ]
      ++ lib.optionals isLinux [
        pkgs.bitwarden-cli
        pkgs.bitwarden-desktop
        pkgs.todoist-electron
      ];

    homebrew.casks = lib.mkIf isDarwin [
      "bitwarden"
      "todoist"
    ];
  };
}
