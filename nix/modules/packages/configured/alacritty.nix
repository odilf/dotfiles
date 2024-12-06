{
  lib,
  config,
  pkgs,
  ...
}:
let
  # eachHome = (lib.traceVal (import ../../utils.nix { inherit lib pkgs config; }).packages).eachHome;
  # inherit (lib.traceVal (import ../../utils.nix { inherit lib pkgs config; }).packages) eachHome;
  utils = import ../../utils.nix { inherit lib pkgs config; };
in
{
  options.packages.configured.alacritty = {
    enable = lib.mkEnableOption "alacritty";
  };

  config = utils.eachHome {
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
  };
}
