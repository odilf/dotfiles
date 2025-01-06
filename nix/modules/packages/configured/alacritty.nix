{
  lib,
  config,
  pkgs,
  ...
}:
let
  utils = import ../../utils.nix { inherit lib pkgs config; };
  cfg = config.packages.configured.fish;
in
{
  options.packages.configured.alacritty = {
    enable = lib.mkEnableOption "alacritty";
  };

  config = lib.mkIf cfg.enable (
    utils.eachHome {
      programs.alacritty = {
        enable = true;
        settings = {
          terminal.shell = "${pkgs.fish}/bin/fish";

          font.size = 14.0;
          font.normal.family = "ZedMono Nerd Font";
          font.normal.style = "Medium";

          # TODO: Review these settings
          window = {
            decorations = "none";
            dynamic_title = true;
            option_as_alt = "OnlyLeft";
            startup_mode = "Maximized";
          };
        };
      };
    }
  );
}
