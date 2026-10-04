{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  utils = import ../utils.nix { inherit config lib pkgs; };
in
{
  users.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "productivity") {
      packages = [
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
    };

  home-manager.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "productivity") {
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
    };

  homebrew.casks = lib.optionals (isDarwin && utils.bundleEnabled "productivity") [
    "musicbrainz-picard"
    "zotero"
    "calibre"
  ];
}
