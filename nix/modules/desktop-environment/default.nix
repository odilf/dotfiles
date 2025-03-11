{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.desktop-environment;
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  utils = import ../utils.nix { inherit lib pkgs config; };
in
{
  imports = [
    ./linux
    ./darwin
  ];

  config =
    lib.mkIf config.gui {
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

      homebrew = lib.mkIf isDarwin {
        casks = [
          "bitwarden"
          "todoist"
          "syncthing"
        ];

        brews = [
          {
            name = "syncthing";
            restart_service = "changed";
          }
        ];
      };

    }
    // utils.eachHome {
      services.syncthing = {
        enable = true;
        tray.enable = true;
      };
    };
}
