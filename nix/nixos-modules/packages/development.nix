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
  options = {
    development-packages = {
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
  };

  config = lib.mkIf cfg.enable {
    programs = {
      fish.enable = lib.mkIf cfg.cli true;
    };

    environment = {
      systemPackages =
        with pkgs;
        let
          default = [
            vim
            git
          ];
          cli-general = [
            bat
            bottom
            btop
            curl
            dua
            eza
            fd
            starship
            ripgrep
            rsync
            tokei
            vim
            neovim
            wget
            yazi
            zellij
            zoxide
          ];
          cli-darwin = [ darwin.trash ];

          cli = lib.mkMerge [
            cli-general
            (lib.mkIf pkgs.stdenv.isDarwin cli-darwin)
          ];

          rust = [ bacon ];
        in
        lib.mkMerge [
          default
          (lib.mkIf cfg.cli cli)
          (lib.mkIf cfg.rust rust)
        ];
    };
  };
}
