{ ... }:
let
  minecraftDisabledCondition = value: {
    type = "variable_if";
    name = "minecraft_hotkeys_disabled";
    value = value;
  };

  minecraftConditions = [
    # Minecraft (Prism Launcher) runs as a plain Java process with no bundle
    # identifier, so it is matched by file path instead.
    {
      type = "frontmost_application_if";
      bundle_identifiers = [ "^com\\.slackow\\.SlackowWall$" ];
      file_paths = [ "PrismLauncher/java/.*/bin/java$" ];
    }
    (minecraftDisabledCondition 0)
  ];

  gameKey = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers.optional = [ "any" ];
    };
    to = [ { key_code = to; } ];
    conditions = minecraftConditions;
  };

  gamePointingButton = from: to: {
    type = "basic";
    from = {
      pointing_button = from;
      modifiers.optional = [ "any" ];
    };
    to = [ { key_code = to; } ];
    conditions = minecraftConditions;
  };

  toggleKey = value: {
    type = "basic";
    from = {
      key_code = "m";
      modifiers.mandatory = [ "fn" ];
    };
    to = [
      {
        set_variable = {
          name = "minecraft_hotkeys_disabled";
          value = value;
        };
      }
    ];
    conditions = [ (minecraftDisabledCondition (if value == 1 then 0 else 1)) ];
  };
in
{
  home-manager.users."*".programs.karabiner.rules = [
    {
      description = "Toggle mcsr hotkeys (Fn+M)";
      manipulators = [
        (toggleKey 1)
        (toggleKey 0)
      ];
    }
    {
      # Free accessible keys:
      # - alt
      # - x
      description = "mcsr hotkeys";
      manipulators = [
        (gameKey "1" "f12")
        (gameKey "2" "f16")
        (gameKey "3" "f17")
        (gameKey "4" "f18")
        (gameKey "5" "0")
        (gameKey "f1" "1")
        (gameKey "f2" "2")
        (gameKey "f3" "3")
        (gameKey "f4" "4")
        (gameKey "f5" "5")
        (gameKey "f6" "6")
        (gameKey "f7" "7")
        (gameKey "f8" "8")
        (gameKey "f9" "9")
        (gameKey "left_control" "right_shift")
        (gameKey "a" "o")
        (gameKey "o" "a")
        (gameKey "d" "m")
        (gameKey "m" "d")
        (gamePointingButton "button4" "f3")
      ];
    }
  ];
}
