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

  default = [
    pkgs.vim
    pkgs.git
  ];

  cli = lib.optionals cfg.cli (
    [
      pkgs.bat
      pkgs.bottom
      pkgs.btop
      pkgs.curl
      pkgs.dua
      # pkgs.eza
      pkgs.fd
      pkgs.pfetch-rs
      # pkgs.starship
      pkgs.ripgrep
      pkgs.rsync
      # pkgs.thefuck
      pkgs.tokei
      pkgs.vim
      pkgs.neovim
      pkgs.wget
      pkgs.yazi
      pkgs.zellij
      # pkgs.zoxide
    ]
    ++ lib.optionals isDarwin [
      pkgs.darwin.trash
    ]
    ++ lib.optionals isLinux [
      pkgs.mosh # Broken on darwin
    ]
  );

  rust = lib.optionals cfg.rust [ pkgs.bacon ];

  gui =
    lib.optionals config.packages.gui [
      pkgs.cool-retro-term
      # pkgs.neovide
      pkgs.qbittorrent
    ]
    ++ lib.optionals isLinux [
      pkgs.vscodium
    ];
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
      packages.configured.alacritty.enable = true;

      programs = {
        fish.enable = lib.mkIf cfg.cli true;
      };

      environment.systemPackages = default ++ cli ++ rust ++ gui;

      # Swap escape and caps lock in tty
      services.xserver.xkb.options = lib.mkIf isLinux "ctrl:swapcaps";
      console.useXkbConfig = lib.mkIf isLinux true;

      homebrew.brews = lib.optionals (isDarwin && cfg.cli) [
        "mosh"
      ];
    }

    // utils.eachHome {
      home.packages = default ++ cli ++ rust ++ gui;
      # home.file.".config/karabiner".source = ../../../karabiner;
      # home.file.".config/nvim".source = ../../../nvim;
      # home.stateVersion = "24.11";
    };
}
