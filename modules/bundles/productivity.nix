{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  enabled = user: config.custom.bundles.${user}.productivity.enable;
  enabledForAnyUser = lib.any enabled (builtins.attrNames config.custom.bundles);
in
{
  home-manager.users = lib.mapAttrs (
    user: _:
    lib.mkIf (enabled user) {
      home.packages = [
      ]
      ++ lib.optionals config.gui (
        [
          pkgs.localsend
          # Zotero needs a whole ass firefox, and I don't need zotero rn.
          # pkgs.zotero
        ]
        ++ lib.optionals isLinux [
          pkgs.libreoffice
          pkgs.picard
          pkgs.calibre
        ]
      );

      programs = {
        sioyek.enable = true;
        khal.enable = true;
        # khard.enable = true;
        meli.enable = true;
        himalaya.enable = true;
      };

      xdg.mimeApps = lib.mkIf isLinux {
        enable = true;
        defaultApplications = {
          "application/pdf" = [ "sioyek.desktop" ];
        };
      };
    }
  ) config.custom.bundles;

  homebrew.casks = lib.optionals (isDarwin && enabledForAnyUser) [
    "musicbrainz-picard"
    "zotero"
    "calibre"
  ];
}
