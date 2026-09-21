{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  cfg = config.programs.mcsr;

  syncStandardsettings = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      instance: src:
      let
        instanceDir = "${cfg.prismInstancesDir}/${instance}";
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
    enable = lib.mkEnableOption "Minecraft speedrunning tooling (NinjabrainBot, StandardSettings sync, ...)";

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
      default =
        if isDarwin then
          "${config.home.homeDirectory}/Library/Application Support/PrismLauncher/instances"
        else
          { todo = "set default on linux"; };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optionals isDarwin [
        pkgs.ninjabrain-bot-app
        pkgs.mac-speedrunning-tools
      ]
      ++ lib.optionals isLinux [
        pkgs.waywall
        pkgs.ninjabrain-bot
      ];

    home.activation.mcsrStandardsettings = lib.hm.dag.entryAfter [
      "writeBoundary"
    ] syncStandardsettings;
  };
}
