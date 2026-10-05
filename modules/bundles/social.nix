{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  enabled = user: config.custom.bundles.${user}.social.enable;
  enabledForAnyUser = lib.any enabled (builtins.attrNames config.custom.bundles);
in
{
  home-manager.users = lib.mapAttrs (
    user: _:
    lib.mkIf (enabled user) {
      home.packages = [
        pkgs.nchat
        pkgs.discordo
      ]
      ++ lib.optionals isLinux [
        pkgs.termsonic
      ]
      ++ lib.optionals config.gui (
        lib.optionals isLinux [
          pkgs.signal-desktop
          pkgs.karere
          pkgs.element-desktop
        ]
        ++ lib.optionals isDarwin [
          # pkgs.whatsapp-for-mac # Fails to download
        ]
      );

      programs = {
        gurk-rs.enable = true;
        meli.enable = true;
        # iamb.enable = true;
      };
    }
  ) config.custom.bundles;

  homebrew.casks = lib.optionals (isDarwin && enabledForAnyUser) [
    "whatsapp" # workaround
    "signal"
    "element"
  ];
}
