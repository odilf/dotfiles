{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
lib.mkIf config.gui {
  programs.niri.enable = isLinux;
  programs.xwayland.enable = isLinux;

  homebrew = lib.mkIf isDarwin {
    brews = [
      "batt" # Keep battery at specific percentage
    ];

    casks = [
      "bitwarden"
      "surfshark"
      "transmission"
      # TODO: Would be nice to use the nixpkgs version, but for some reason
      # aerospace refuses to manage it on macos
      "librewolf"
      # TODO: Should be redundant to have karabiner here and in home-manager.
      "karabiner-elements"
      # TODO: Replace with viciane when it works on darwin
      # https://github.com/nix-community/home-manager/issues/9808
      "raycast"
    ];
  };

  home-manager.sharedModules = [
    {
      programs = {
        cmus.enable = true;
        librewolf.enable = true;
        mpv.enable = true;
        vicinae.enable = isLinux;

        aerospace.enable = isDarwin;
        karabiner.enable = isDarwin;
      };

      services.syncthing = {
        enable = true;
        # TODO: Maybe this technically goes into `configuration/`
        tray.enable = isLinux;
      };

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
    }
  ];
}
