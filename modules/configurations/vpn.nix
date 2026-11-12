# TODO: add a darwin equivalent; nix-darwin's wg-quick has no configFile option.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    age.secrets.vpn.file = ../../secrets/vpn.age;

    networking.wg-quick.interfaces.surfshark = {
      configFile = "${config.age.secrets.vpn.path}";
      autostart = false;
    };
  };
}
