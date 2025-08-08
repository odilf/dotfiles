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
      pkgs.bottom
      pkgs.btop
      pkgs.curl
      pkgs.dua
      pkgs.fd
      pkgs.hyperfine
      pkgs.mosh
      pkgs.nh
      pkgs.pfetch-rs
      pkgs.ripgrep
      pkgs.rsync
      pkgs.tokei
      pkgs.vim
      pkgs.wget
      pkgs.yazi
      pkgs.zellij

      # Should arguably be in project devShells, but are convinient to always have
      pkgs.rust-analyzer
      pkgs.nil
      pkgs.nixd
      pkgs.taplo
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
      pkgs.zed-editor-fhs
    ]
    ++ lib.optionals isLinux [
      pkgs.vscodium
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
        bat.enable = true;
        broot.enable = true;
        fish.enable = true;
        ghostty.enable = config.gui;
        git.enable = true;
        helix.enable = true;
        jujutsu.enable = true;
        ssh.enable = true;
      };
    };

  homebrew.casks = lib.optionals (isDarwin && config.gui) [
    "vscodium"
  ];
}
