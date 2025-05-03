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
      pkgs.jujutsu
      pkgs.nil
      pkgs.nixd
    ]
    ++ lib.optionals isDarwin [
      pkgs.darwin.trash
    ]
    ++ lib.optionals isLinux [
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

  config = lib.mkIf cfg.enable (
    {
      packages.configured = lib.mkIf cfg.cli {
        alacritty.enable = lib.mkIf config.packages.gui true;
        fish.enable = true;
        git.enable = true;
        editor.enable = true;
      };

      environment.systemPackages = cli ++ rust ++ gui;

      homebrew.casks = lib.optionals (isDarwin && config.packages.gui) [
        "vscodium"
      ];

      environment.variables.PAGER = lib.mkIf cfg.cli "bat";
    }

    // utils.eachHome {
      home.packages = cli ++ rust ++ gui;

      programs = {
        bat.enable = cfg.cli;
        bat.config = {
          theme = "TwoDark";
        };

        jujutsu = {
          enable = cfg.cli;
          settings = {
            user = {
              name = "odilf";
              email = "odysseas.maheras@gmail.com";
            };

            ui = {
              pager = "${pkgs.bat}/bin/bat";
              default-command = "log";
              merge-editor = ":builting";
            };
          };
        };
      };
    }
  );
}
