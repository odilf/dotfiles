{ ... }:
let
  minecraftDisabledCondition = value: {
    type = "variable_if";
    name = "minecraft_hotkeys_disabled";
    value = value;
  };

  gameKey = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers.optional = [ "any" ];
    };
    to = [ { key_code = to; } ];
    conditions = [
      # Minecraft (Prism Launcher) runs as a plain Java process with no bundle
      # identifier, so it is matched by file path instead.
      {
        type = "frontmost_application_if";
        bundle_identifiers = [ "^com\\.slackow\\.SlackowWall$" ];
        file_paths = [ "PrismLauncher/java/.*/bin/java$" ];
      }
      (minecraftDisabledCondition 0)
    ];
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
  custom.karabiner.rules = [
    {
      description = "Toggle Minecraft / SlackowWall hotkeys (Fn+M)";
      manipulators = [
        (toggleKey 1)
        (toggleKey 0)
      ];
    }
    {
      description = "Minecraft / SlackowWall hotkeys";
      manipulators = [
        (gameKey "left_control" "f3")
        (gameKey "1" "f12")
        (gameKey "2" "f16")
        (gameKey "3" "f17")
        (gameKey "4" "f18")
        (gameKey "left_shift" "f20")
        (gameKey "left_option" "f19")
        (gameKey "left_command" "left_shift")
      ];
    }
  ];
}
