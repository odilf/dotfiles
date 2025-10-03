{
  pkgs,
  lib,
  config,
  ...
}:
let
  enable = user: config.custom.bundles."${user}".productivity.enable;
  inherit (pkgs.stdenv.hostPlatform) isLinux isx86_64;
in
{
  users.users."*" =
    user:
    lib.mkIf (enable user) {
      packages = lib.optionals config.gui (
        lib.optionals isx86_64 [
          pkgs.zotero
        ]
        ++ lib.optionals isLinux [
          pkgs.picard
        ]
      );
    };

  homebrew.casks = [
    "musicbrainz-picard"
  ];
}
