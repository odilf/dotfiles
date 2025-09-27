{
  pkgs,
  lib,
  config,
  ...
}:
let
  enable = user: config.custom.bundles."${user}".productivity.enable;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  users.users."*" =
    user:
    lib.mkIf (enable user) {
      packages = lib.optionals config.gui (
        [
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
