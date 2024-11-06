{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.desktop-environment;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
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
