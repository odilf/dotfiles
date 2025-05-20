{
  pkgs,
  lib,
  config,
  ...
}:
{
  users.users."*".packages = lib.optionals config.gui [
    pkgs.zotero
  ];
}
