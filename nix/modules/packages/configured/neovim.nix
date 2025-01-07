{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  utils = import ../../utils.nix { inherit lib pkgs config; };
  cfg = config.packages.configured.neovim;
in
{
  options.packages.configured.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable (
    utils.eachHome {
      xdg.configFile.nvim.source = ../../../../nvim;
      programs.neovim.enable = true;
    } // {
      # Also enable it system-wide
      programs.neovim = lib.mkIf isLinux {
        enable = true;
        defaultEditor = true;
      };

      environment.variables."EDITOR" = "nvim";
    }
  );
}
