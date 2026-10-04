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
    programs.localsend.enable = true;

    homebrew = lib.mkIf isDarwin {
      casks = [
        "bitwarden"
        "surfshark" # VPN
        "transmission"
        # TODO: Would be nice to use the nixpkgs version, but for some reason
        # aerospace refuses to manage it on macos
        "librewolf"
      ];
    };

    # TODO: Don't hardcode main user
    home-manager.users.odilf = {
      home.packages = [
        pkgs.libqalculate
        pkgs.dump-thought
      ]
      ++ lib.optionals isLinux [
        pkgs.qimgv
        pkgs.bitwarden-desktop
        pkgs.vlc
        pkgs.qalculate-qt
        pkgs.qbittorrent
        pkgs.wl-clipboard
        pkgs.kdePackages.dolphin
      ]
      ++ lib.optionals isDarwin [
        pkgs.iina
      ];

      programs = {
        cmus.enable = true;
        librewolf.enable = true;
        mpv.enable = true;
      };

      services.syncthing = {
        enable = true;
        tray.enable = lib.mkIf isLinux true;
      };
    };
  };
}
