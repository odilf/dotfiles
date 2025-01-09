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
      programs.neovim = {
        enable = true;
        extraPackages = [
          pkgs.deno # For Peek.nvim
          pkgs.nodejs_latest # For copilot and perhaps something else
        ];
      };
    }
    // {
      # Also enable it system-wide
      environment.variables."EDITOR" = "nvim";
    }
  );
}
