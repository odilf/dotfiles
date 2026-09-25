{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  cfg = config.programs.mcsr;

  invert =
    attrs:
    builtins.listToAttrs (
      lib.mapAttrsToList (name: value: {
        name = value;
        value = name;
      }) attrs
    );

  make-cycles =
    binds:
    let
      inverseBinds = invert binds;

      # Walk backwards through inverseBinds from `source` until we hit a
      # node with no predecessor (the root of the chain), then pair that
      # root with `target`.
      findRoot =
        source: target:
        if inverseBinds ? ${source} then
          findRoot inverseBinds.${source} target
        else
          {
            key = target;
            target = source;
          };
    in
    lib.concatLists (
      lib.mapAttrsToList (
        key: target: [ { inherit key target; } ] ++ lib.optional (!binds ? ${target}) (findRoot key target)
      ) binds
    );
in
{
  options.programs.mcsr = {
    enable = lib.mkEnableOption "Minecraft speedrunning tooling (NinjabrainBot, StandardSettings, etc)";

    standardsettings = lib.mkOption {
      description = "Prism Launcher instance name -> standardsettings.json to sync into that instance";
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = {
        Ranked = ./standardsettings.json;
      };
    };

    rebinds = lib.mkOption {
      description = "Physical keyboard rebinds. Populates `rebind-cycle` that gives full legal rebinds to apply with some rebinding program.";
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        "a" = "o";
        "d" = "m";

        "4" = "f18";
        "f4" = "4";
        "0" = "f4";
      };
    };

    rebind-cycle = lib.mkOption {
      description = "Legal one-to-one rebinds derived from `rebinds`, as a list of `physical key -> key to trigger` pairs.";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            key = lib.mkOption {
              type = lib.types.str;
              description = "Physical key to rebind";
            };
            target = lib.mkOption {
              type = lib.types.str;
              description = "Key that `key` triggers";
            };
          };
        }
      );
      readOnly = true;
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

    programs.mcsr.rebind-cycle = make-cycles cfg.rebinds;

    home.activation.mcsrStandardsettings =
      let
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
      lib.hm.dag.entryAfter [
        "writeBoundary"
      ] syncStandardsettings;
  };
}
