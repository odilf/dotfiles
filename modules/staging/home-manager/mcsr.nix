{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  cfg = config.programs.mcsr;

  syncStandardsettings = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      instance: src:
      let
        instanceDir = "${config.home.homeDirectory}/${cfg.prismInstancesDir}/${instance}";
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
{
  options.programs.mcsr = {
    enable = lib.mkEnableOption "Minecraft speedrunning tooling (NinjabrainBot, MST, StandardSettings sync)";

    standardsettings = lib.mkOption {
      description = "Prism Launcher instance name -> standardsettings.json to sync into that instance";
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = {
        Ranked = ./standardsettings.json;
      };
    };

    prismInstancesDir = lib.mkOption {
      description = "Prism Launcher instances directory, relative to the home directory";
      type = lib.types.str;
      default = "Library/Application Support/PrismLauncher/instances";
    };
  };

  config = lib.mkIf (isDarwin && cfg.enable) {
    home.packages = [
      pkgs.ninjabrain-bot-app
      pkgs.mac-speedrunning-tools
    ];

    home.activation.mcsrStandardsettings = lib.hm.dag.entryAfter [
      "writeBoundary"
    ] syncStandardsettings;
  };
}
