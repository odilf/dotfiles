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
          pkgs.vit
          pkgs.taskwarrior-tui
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

  home-manager.users."*".programs.taskwarrior.enable = true;

  homebrew.casks = [
    "musicbrainz-picard"
    "zotero"
    "calibre"
  ];
}
