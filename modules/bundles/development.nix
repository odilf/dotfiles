{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  enabled = user: config.custom.bundles.${user}.development.enable;
  enabledForAnyUser = lib.any enabled (builtins.attrNames config.custom.bundles);

  cli = [
    (pkgs.aspellWithDicts (d: [
      d.en
      d.es
    ]))
    pkgs.hyperfine
    pkgs.tokei
    pkgs.vim
    pkgs.watchexec

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
  ];

  gui = lib.optionals config.gui (
    lib.optionals isLinux [
      pkgs.cool-retro-term
      pkgs.vscodium
      pkgs.zed-editor
    ]
  );
in
{
  home-manager.users = lib.mapAttrs (
    user: _:
    lib.mkIf (enabled user) {
      home.packages = cli ++ gui;

      programs = {
        fish.enable = true;
        helix.enable = true;

        alacritty.enable = config.gui;
        ghostty.enable = config.gui;
        # wezterm.enable = config.gui;

        git.enable = true;
        jujutsu.enable = true;
        ssh.enable = true;

        # mistral-vibe.enable = true;
        pi-coding-agent.enable = true;
      };

      home.sessionVariables = {
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };
    }
  ) config.custom.bundles;

  homebrew.casks = lib.optionals (isDarwin && config.gui && enabledForAnyUser) [
    "ghostty"
    "vscodium"
    "zed"
  ];
}
