{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  utils = import ../utils.nix { inherit config lib pkgs; };

  cli = [
    (pkgs.aspellWithDicts (d: [
      d.en
      d.es
    ]))
    pkgs.bottom
    pkgs.btop
    pkgs.curl
    pkgs.dust
    pkgs.dua
    pkgs.fd
    pkgs.hyperfine
    pkgs.mosh
    pkgs.nh
    pkgs.ripgrep
    pkgs.rsync
    pkgs.tokei
    pkgs.vim
    pkgs.watchexec
    pkgs.wget
    pkgs.wiki-tui

    # Should arguably be in project devShells, but are convinient to always have
    pkgs.cargo
    pkgs.rust-analyzer
    pkgs.rustfmt
    pkgs.clippy
    pkgs.rustc
    pkgs.bacon

    pkgs.nil
    pkgs.nixd
    pkgs.taplo
    pkgs.marksman
    pkgs.uv
    pkgs.ruff
    pkgs.ty
    pkgs.vscode-langservers-extracted
  ]
  ++ lib.optionals isDarwin [
    pkgs.darwin.trash
  ]
  ++ lib.optionals isLinux [
    pkgs.trashy
  ];

  gui = lib.optionals config.gui (
    lib.optionals isLinux [
      pkgs.cool-retro-term
      pkgs.vscodium
      pkgs.zed-editor
    ]
  );

  enable = user: config.custom.bundles.${user}.development.enable;
in
{
  users.users."*" =
    { user, ... }:
    lib.mkIf (enable user) {
      packages = cli ++ gui;
    };

  programs.fish.enable = lib.mkIf (utils.bundleEnabled "development") true;

  home-manager.users."*" =
    { user, ... }:
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
        pi-coding-agent.enable = true;
        ripgrep.enable = true;
        ripgrep-all.enable = true;
        ssh.enable = true;
        wezterm.enable = config.gui;
        yazi.enable = true;
        zellij.enable = true;
      };

      home.sessionVariables = {
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };
    };

  homebrew.casks = lib.optionals (isDarwin && config.gui && utils.bundleEnabled "development") [
    "cool-retro-term"
    "ghostty"
    "vscodium"
    "zed"
  ];

}
