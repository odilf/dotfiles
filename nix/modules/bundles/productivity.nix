{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isx86_64;
in
{
  users.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "productivity") {
      packages = [
        pkgs.taskwarrior-tui
        pkgs.tasksh
        pkgs.ytermusic
      ]
      ++ lib.optionals config.gui (
        [
          pkgs.localsend

        ]
        ++ lib.optionals isx86_64 [
          pkgs.zotero
        ]
        ++ lib.optionals isLinux [
          pkgs.libreoffice
          pkgs.picard
          pkgs.calibre
        ]
      );
    };

  home-manager.users."*" = {
    programs = {
      taskwarrior.enable = true;
      zathura.enable = true;
      sioyek.enable = true;
      khal.enable = true;
      khard.enable = true;
      cmus.enable = true;
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

  homebrew.casks = [
    "musicbrainz-picard"
    "zotero"
    "calibre"
  ];
}
