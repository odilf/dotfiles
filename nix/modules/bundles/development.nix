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
      pkgs.dust
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
      pkgs.rustc
      pkgs.cargo
      pkgs.bacon
      pkgs.rustfmt

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

  gui = lib.optionals config.gui (
    [
      pkgs.qbittorrent
    ]
    ++ lib.optionals isLinux [
      pkgs.cool-retro-term
      pkgs.vscodium
      pkgs.zed-editor
    ]
  );

  enable = user: config.custom.bundles."${user}".development.enable;
in
{
  users.users."*" =
    user:
    lib.mkIf (enable user) {
      packages = cli ++ gui;
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
        ssh = {
          enable = true;
          enableDefaultConfig = false;
        };
      };

      home.sessionVariables = {
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };
    };

  homebrew.casks = lib.optionals (isDarwin && config.gui) [
    "cool-retro-term"
    "ghostty"
    "vscodium"
    "zed"
  ];

}
