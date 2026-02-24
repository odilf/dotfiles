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
      packages = lib.optionals config.gui (
        [
          pkgs.taskwarrior-tui
          pkgs.tasksh
          pkgs.libreoffice
          pkgs.localsend
        ]
        ++ lib.optionals isx86_64 [
          pkgs.zotero
        ]
        ++ lib.optionals isLinux [
          pkgs.picard
          pkgs.calibre
        ]
      );
    };

  home-manager.users."*" = {
    programs = {
      taskwarrior.enable = true;
      zathura.enable = true;
      khal.enable = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      };
    };
  };

  homebrew.casks = [
    "musicbrainz-picard"
    "zotero"
    "calibre"
  ];
}
