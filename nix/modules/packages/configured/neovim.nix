{
  lib,
  config,
  pkgs,
  ...
}:
let
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
    }
  );
}
