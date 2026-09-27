{ lib, pkgs, ... }:
{
  home-manager.users."*" =
    { hmConfig, ... }:
    let
      enabled = hmConfig.programs.mcsr.enable;
    in
    {
      programs = {
        # Not declaratively configured:
        # - NinjabrainBot settings
        # - SlackowWall settings
        # - MST settings
        mcsr = {
          rebinds = {
            # mo' convinient
            "button4" = "f3";

            # pie chart
            # access to hotkeys without changing pie
            "1" = "f13";
            "2" = "f16";
            "3" = "f17";
            "4" = "f18";
            # alternative navigation
            "5" = "0";
            "f1" = "1";
            "f2" = "2";
            "f3" = "3";
            "f4" = "4";
            "f5" = "5";
            "f6" = "6";
            "f7" = "7";
            "f8" = "8";
            "f9" = "9";
            # pie without shifting
            "left_control" = "right_shift";

            # search-crafting
            # (ref: https://docs.google.com/document/d/19nlwej-fUvKYNf1SX_u0Ks-WlfR30Ke2RQ-hYPxpMF4/edit?tab=t.0)
            "q" = "o";
            "a".trigger = "m";
            "d" = "home";
            "tab".trigger = "f12";

            # f3+f4 gamemode change
            "0" = "f4";
          };

          standardsettings = {
            "Ranked" = ./mcsr/standardsettings.json;
            "Ranked Practice" = ./mcsr/standardsettings.json;
            "Speedrunning" = ./mcsr/standardsettings.json;
          };
        };

        karabiner.rules =
          let
            # Karabiner condition matching the `minecraft_hotkeys_disabled` variable.
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

            # Karabiner uses `key_code` for keys and `pointing_button` for mouse
            # buttons; `button*` names are pointing buttons.
            buttonOrKey =
              name: if lib.hasPrefix "button" name then { pointing_button = name; } else { key_code = name; };

            # Cursor captured (Minecraft grabbed the mouse) vs. free (chat, menus).
            cursorCapturedCondition = {
              type = "variable_if";
              name = "minecraft_cursor_captured";
              value = 1;
            };

            cursorFreeCondition = {
              type = "variable_if";
              name = "minecraft_cursor_captured";
              value = 0;
            };

            # Build a Karabiner manipulator remapping `from` to `to`, gated by `extraConditions`.
            gameBind = extraConditions: from: to: {
              type = "basic";
              from = (buttonOrKey from) // {
                modifiers.optional = [ "any" ];
              };
              to = [ (buttonOrKey to) ];
              conditions = minecraftConditions ++ extraConditions;
            };

            # Manipulator that flips `minecraft_hotkeys_disabled` to `value` on fn+m.
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
              conditions = [ (minecraftDisabledCondition (1 - value)) ];
            };
          in
          lib.mkIf enabled {
            mcsr-hotkeys = {
              description = "mcsr hotkeys";
              manipulators = [
                (toggleKey 1)
                (toggleKey 0)
              ]
              # `rebind-mappings` groups are gated by cursor state: unconditional
              # always, triggered only while captured, typed only while free.
              ++ lib.map (
                { key, target }: gameBind [ ] key target
              ) hmConfig.programs.mcsr.rebind-mappings.unconditional
              ++ lib.map (
                { key, target }: gameBind [ cursorCapturedCondition ] key target
              ) hmConfig.programs.mcsr.rebind-mappings.triggered
              ++ lib.map (
                { key, target }: gameBind [ cursorFreeCondition ] key target
              ) hmConfig.programs.mcsr.rebind-mappings.typed;
            };
          };
      };

      # Mirror macOS cursor visibility into a Karabiner variable so the typable
      # rebinds above only fire while Minecraft has the mouse captured.
      launchd.agents.karabiner-cursor-state =
        lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin && hmConfig.programs.mcsr.enable)
          {
            enable = enabled;
            config = {
              ProgramArguments = [ "${pkgs.karabiner-cursor-state}/bin/karabiner-cursor-state" ];
              EnvironmentVariables = {
                CURSOR_CAPTURED_VARIABLE = "minecraft_cursor_captured";
              };
              RunAtLoad = true;
              KeepAlive = true;
              StandardOutPath = "${hmConfig.home.homeDirectory}/Library/Logs/karabiner-cursor-state.log";
              StandardErrorPath = "${hmConfig.home.homeDirectory}/Library/Logs/karabiner-cursor-state.err";
            };
          };
    };
}
