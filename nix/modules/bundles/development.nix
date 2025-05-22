{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  cli =
    [
      pkgs.bat
      pkgs.bottom
      pkgs.btop
      pkgs.curl
      pkgs.dua
      pkgs.fd
      pkgs.nh
      pkgs.pfetch-rs
      pkgs.ripgrep
      pkgs.rsync
      pkgs.tokei
      pkgs.vim
      pkgs.mosh
      pkgs.wget
      pkgs.yazi
      pkgs.zellij

      # Should arguably be in project devShells, but are convinient to always have
      pkgs.rust-analyzer
      pkgs.nil
      pkgs.nixd
    ]
    ++ lib.optionals isDarwin [
      pkgs.darwin.trash
    ]
    ++ lib.optionals isLinux [
      pkgs.trashy
    ];

  rust = [
    pkgs.cargo
    pkgs.rust-analyzer
    pkgs.bacon
  ];

  gui = lib.optionals config.gui (
    [
      pkgs.cool-retro-term
      pkgs.qbittorrent
    ]
    ++ lib.optionals isLinux [
      pkgs.vscodium
      pkgs.neovide
    ]
  );

  enable = user: config.custom.bundles."${user}".development.enable;
in
{
  users.users."*" =
    user:
    lib.mkIf (enable user) {
      packages = cli ++ rust ++ gui;
    };

  programs.fish.enable = true;

  home-manager.users."*" =
    user:
    lib.mkIf (enable user) {
      programs = {
        alacritty.enable = config.gui;
        fish.enable = true;
        git.enable = true;
        helix.enable = true;
        jujutsu.enable = true;
        bat.enable = true;
      };
    };

  homebrew.casks = lib.optionals (isDarwin && config.gui) [
    "vscodium"
  ];
}
