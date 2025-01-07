{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages.development;

  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  utils = import ../utils.nix { inherit lib pkgs config; };

  cli = lib.optionals cfg.cli (
    [
      pkgs.bat
      pkgs.bottom
      pkgs.btop
      pkgs.curl
      pkgs.dua
      pkgs.fd
      pkgs.pfetch-rs
      pkgs.ripgrep
      pkgs.rsync
      pkgs.tokei
      pkgs.vim
      pkgs.mosh
      pkgs.wget
      pkgs.yazi
      pkgs.zellij
    ]
    ++ lib.optionals isDarwin [
      pkgs.darwin.trash
    ] ++ lib.optionals isLinux [
      pkgs.trashy
    ]
  );

  rust = lib.optionals cfg.rust [ pkgs.bacon ];

  gui = lib.optionals config.packages.gui (
    [
      pkgs.cool-retro-term
      pkgs.qbittorrent
    ]
    ++ lib.optionals isLinux [
      pkgs.vscodium
      pkgs.neovide
    ]
  );
in
{
  options.packages.development = {
    enable = lib.mkEnableOption "Packages used for developing software";

    cli = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Add packages for navigating the command line and monitoring the system, 
        such as `eza`, `ripgrep`, `tokei` and `btop`.
      '';
    };

    rust = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Rust-related development packages, that should not always belong in project flakes, such as `bacon`.
      '';
    };
  };

  config =
    lib.mkIf cfg.enable {
      packages.configured = lib.mkIf cfg.cli {
        alacritty.enable = true;
        fish.enable = true;
        git.enable = true;
        neovim.enable = true;
      };

      environment.systemPackages = cli ++ rust ++ gui;

      homebrew.casks = lib.optionals (isDarwin && config.packages.gui) [
        "vscodium"
      ];
    }

    // utils.eachHome {
      home.packages = cli ++ rust ++ gui;
    };
}
