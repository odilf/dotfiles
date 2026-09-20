{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  cfg = config.custom.mcsr;
in
{
  home-manager.users."*" =
    { hmConfig, ... }:
    let
      instancesDir = "${hmConfig.home.homeDirectory}/${cfg.prismInstancesDir}";

      syncStandardsettings = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          instance: src:
          let
            instanceDir = "${instancesDir}/${instance}";
          in
          ''
            if [ -d "${instanceDir}" ]; then
              DEST="${instanceDir}/minecraft/config/mcsr/standardsettings.json"
              $DRY_RUN_CMD mkdir -p "$(dirname "$DEST")"
              $DRY_RUN_CMD cp -f ${src} "$DEST"
            fi
          ''
        ) cfg.standardsettings
      );
    in
    lib.mkIf (isDarwin && cfg.enable) {
      home.packages = [
        pkgs.ninjabrain-bot-app
        pkgs.mac-speedrunning-tools
      ];

      home.activation.mcsrStandardsettings = hmConfig.lib.dag.entryAfter [
        "writeBoundary"
      ] syncStandardsettings;
    };
}
