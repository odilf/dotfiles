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

  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  options.packages.social = {
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
    environment.systemPackages = lib.optionals config.packages.gui (
      [
        pkgs.discord
        # pkgs.telegram-desktop # Fails to download
        pkgs.nchat
      ]
      ++ lib.optionals isLinux [
        pkgs.whatsapp-for-linux
        pkgs.teams-for-linux
      ]
      ++ lib.optionals isDarwin [
        # pkgs.whatsapp-for-mac # Fails to download
      ]
    );

    homebrew.casks = lib.optionals isDarwin [
      "whatsapp" # workaround
      "microsoft-teams" # workaround too I think?
      "telegram"
    ];
  };
}
