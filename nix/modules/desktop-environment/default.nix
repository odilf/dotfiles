{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  imports = [
    ./darwin.nix
    ./gnome.nix
    ./hyprland.nix

    ./laptop.nix
  ];

  options.desktop-environment = lib.mkOption {
    type = lib.types.enum (
      if isDarwin then
        [ "macOS" ]
      else
        [
          "cosmic"
          "gnome"
          "hyprland"
        ]
    );
    default = "none";
  };

  config = lib.mkIf config.gui {
    environment.systemPackages =
      [
        pkgs.firefox-beta
        pkgs.todoist
        pkgs.qalculate-qt
      ]
      ++ lib.optionals isLinux [
        pkgs.bitwarden
        pkgs.todoist-electron
        pkgs.deadbeef
        pkgs.vlc # TODO: Check if this is good.
      ]
      ++ lib.optionals isDarwin [
        pkgs.iina
      ];

    homebrew = lib.mkIf isDarwin {
      casks = [
        "bitwarden"
        "surfshark" # VPN
        "deadbeef@nightly"
      ];
    };

    # TODO: Don't hardcode main user
    home-manager.users.odilf = {
      services.syncthing = {
        enable = true;
        tray.enable = lib.mkIf isLinux true;
      };
    };
  };
}
