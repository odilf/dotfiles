{
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  programs.niri.enable = isLinux;
  programs.xwayland.enable = isLinux;

  home-manager.sharedModules = [
    {
      programs = {
        cmus.enable = true;
        librewolf.enable = true;
        mpv.enable = true;
        vicinae.enable = isLinux;
        sioyek.enable = true;

        aerospace.enable = isDarwin;
        karabiner.enable = isDarwin;

        theme-switch.enable = true;
      };

      services.syncthing = {
        enable = true;
        # TODO: Maybe this technically goes into `configuration/`
        tray.enable = isLinux;
      };

      home.packages = [
        pkgs.libqalculate
        pkgs.dump-thought
        pkgs.wiki-tui
        pkgs.localsend
      ]
      ++ lib.optionals isLinux [
        pkgs.qimgv
        pkgs.qbittorrent
        pkgs.wl-clipboard
      ]
      ++ lib.optionals isDarwin [
        pkgs.iina
      ];
    }
  ];

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
}
