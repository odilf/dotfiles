# TODO:
# - [ ] Whatsapp
# - [ ] Discord/legcord
# - [ ] Matrix
# - [ ] Bluesky
# - [ ] Mail?
# - [ ] Terminal clients for all of the above

{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages.social;
in
{
  options.social = {
    enable = lib.mkEnableOption "Packages used to communicate with fellow humans";

    # cli = lib.mkOption {
    #   type = lib.types.bool;
    #   default = true;
    #   description = ''
    #     Add packages for navigating the command line and monitoring the system, 
    #     such as `eza`, `ripgrep`, `tokei` and `btop`.
    #   '';
    # };
  };

  config = lib.mkIf cfg.enable {
    environment =
      {
      };
  };
}
