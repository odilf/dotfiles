{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.development-packages;
in
{
  options.development-packages = {
    enable = lib.mkEnableOption "development-packages";

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

  config = lib.mkIf cfg.enable {
    programs = {
      fish.enable = lib.mkIf cfg.cli true;
    };

    environment = {
      systemPackages =
        with pkgs;
        let
          isDarwin = stdenv.hostPlatform.isDarwin;

          default = [
            vim
            git
          ];

          cli =
            [
              bat
              bottom
              btop
              curl
              dua
              eza
              fd
              pfetch-rs
              starship
              ripgrep
              rsync
              thefuck
              tokei
              vim
              neovim
              wget
              yazi
              zellij
              zoxide
            ]
            ++ lib.optionals isDarwin [
              darwin.trash
            ];

          rust = [ bacon ];
        in
        default ++ lib.optionals cfg.cli cli ++ lib.optionals cfg.rust rust;
    };
  };
}
