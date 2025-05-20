{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  utils = import ../utils.nix { inherit config lib pkgs; };
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
  };

  config = lib.mkIf config.gui {
    environment.systemPackages =
      [
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
        "todoist"
        "surfshark" # VPN
        "syncthing"
        "deadbeef@nightly"
      ];
    };

    # home-manager.users = utils.mapUsers (username: {
    #   "${username}".services.syncthing = {
    #     enable = true;
    #     tray.enable = lib.mkIf isLinux true;
    #   };
    # });
  };
}
