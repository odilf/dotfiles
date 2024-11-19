# TODO:
# - [ ] Matrix
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

  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86;
in
{
  options.packages.social = {
    enable = lib.mkEnableOption "Packages used to communicate with fellow humans";

    # TODO: Maybe make options to toggle each service.
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.optionals config.packages.gui (
      [
        pkgs.telegram-desktop # Fails to download
        pkgs.nchat
      ]
      ++ lib.optionals (isx86 || isDarwin) [
        pkgs.discord # Discord not available on aarch-linux :(
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
