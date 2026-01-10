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
    ./niri.nix

    ./laptop.nix
  ];

  options.desktop-environment = lib.mkOption {
    type = lib.types.enum (
      if isDarwin then
        [
          "macOS"
        ]
      else
        [
          "none"
          "niri"
          "gnome"
          "hyprland"
        ]
    );
    default = "none";
  };

  config = lib.mkIf config.gui {
    environment.systemPackages = [
      pkgs.firefox-esr
      pkgs.feishin
    ]
    ++ lib.optionals isLinux [
      pkgs.qimgv
      pkgs.bitwarden-desktop
      pkgs.vlc
      pkgs.qalculate-qt # problem with qtbase
      pkgs.qbittorrent # problem with qtbase

      pkgs.wl-clipboard
    ]
    ++ lib.optionals isDarwin [
      pkgs.iina
    ];

    programs.localsend.enable = true;

    homebrew = lib.mkIf isDarwin {
      casks = [
        "bitwarden"
        "surfshark" # VPN
        "firefox" # TODO: Move back to nixpkgs version when it works
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
