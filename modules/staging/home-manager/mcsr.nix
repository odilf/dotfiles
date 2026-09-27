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

  makeCycles =
    binds:
    let
      inverseBinds = invert binds;

      # Walk backwards through inverseBinds from `source` until we hit a
      # node with no predecessor (the root of the chain), then pair that
      # root with `target`.
      findRoot =
        source: target: visited:
        if builtins.elem source visited then
          throw ''
            programs.mcsr.rebinds: cannot create a one-to-one rebind cycle: the rebinds
            contain a cycle (${lib.concatStringsSep " -> " (visited ++ [ source ])}) that has
            no root. Remove one of the rebinds in the cycle so every chain ends at a key that
            is not itself rebound.
          ''
        else if inverseBinds ? ${source} then
          findRoot inverseBinds.${source} target (visited ++ [ source ])
        else
          {
            key = target;
            target = source;
          };
    in
    lib.concatLists (
      lib.mapAttrsToList (
        key: target:
        [ { inherit key target; } ] ++ lib.optional (!binds ? ${target}) (findRoot key target [ ])
      ) binds
    );

  # Classify a rebind into its activation mode and target key.
  classifyRebind =
    name: value:
    if !builtins.isAttrs value then
      {
        mode = "unconditional";
        target = value;
      }
    else if value.trigger != null && value.type == null then
      {
        mode = "triggered";
        target = value.trigger;
      }
    else if value.type != null && value.trigger == null then
      {
        mode = "typed";
        target = value.type;
      }
    else
      throw "programs.mcsr.rebinds.${name}: must be either `trigger`, `type` or string.";

  rebindModes = [
    "unconditional"
    "triggered"
    "typed"
  ];

  # Split the flat `rebinds` attrset into one `name -> target` attrset per mode.
  rebindsByMode =
    let
      classified = lib.mapAttrs classifyRebind cfg.rebinds;
    in
    lib.genAttrs rebindModes (
      mode:
      lib.mapAttrs (_: rebind: rebind.target) (
        lib.filterAttrs (_: rebind: rebind.mode == mode) classified
      )
    );

  rebindMappings = lib.genAttrs rebindModes (mode: makeCycles rebindsByMode.${mode});

  # Whether every physical key in a resolved rebind list is unique.
  hasUniqueSources =
    binds: builtins.length (lib.unique (map (bind: bind.key) binds)) == builtins.length binds;
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
      description = ''
        Physical keyboard rebinds. Populates `rebind-mappings` that gives full legal
        rebinds to apply with some rebinding program. A plain string is an unconditional
        rebind; `{ trigger = target; }` applies only while the cursor is hidden, and
        `{ type = target; }` only while the cursor is visible.
      '';
      type = lib.types.attrsOf (
        lib.types.either lib.types.str (
          lib.types.submodule {
            options = {
              trigger = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Key to trigger, applied only while the cursor is hidden";
              };
              type = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Key to trigger, applied only while the cursor is visible";
              };
            };
          }
        )
      );
      default = { };
      example = {
        # Unconditional
        "f4" = "4";
        "0" = "f4";

        # Only while the cursor is hidden
        "a".trigger = "o";
        "d".trigger = "m";

        # Only while the cursor is visible
        "q".type = "o";
      };
    };

    rebind-mappings = lib.mkOption {
      description = "Legal one-to-one rebinds derived from `rebinds`, grouped by when they apply: `unconditional`, `triggered` (cursor hidden) or `typed` (cursor visible). Each is a list of `physical key -> key to trigger` pairs.";
      type = lib.types.submodule {
        options =
          let
            # Option type for a list of resolved `key -> target` rebind pairs.
            bindingsType = lib.types.listOf (
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
          in
          lib.genAttrs rebindModes (
            _:
            lib.mkOption {
              type = bindingsType;
              default = [ ];
            }
          );
      };
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

    programs.mcsr.rebind-mappings = rebindMappings;

    assertions = [
      {
        assertion = hasUniqueSources (rebindMappings.unconditional ++ rebindMappings.triggered);
        message = ''
          programs.mcsr.rebinds: the rebinds active while the cursor is hidden map the
          same physical key more than once. A key may only be rebound in one mode, and no
          rebind may target a key that is rebound in another mode active at the same time.
        '';
      }
      {
        assertion = hasUniqueSources (rebindMappings.unconditional ++ rebindMappings.typed);
        message = ''
          programs.mcsr.rebinds: the rebinds active while the cursor is visible map the
          same physical key more than once. A key may only be rebound in one mode, and no
          rebind may target a key that is rebound in another mode active at the same time.
        '';
      }
    ];

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
