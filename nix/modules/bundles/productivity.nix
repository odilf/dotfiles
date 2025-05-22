{
  pkgs,
  lib,
  config,
  ...
}:
let
  enable = user: config.custom.bundles."${user}".productivity.enable;
in
{
  users.users."*" =
    user:
    lib.mkIf (enable user) {
      packages = lib.optionals config.gui [
        pkgs.zotero
      ];
    };
}
