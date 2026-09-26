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
            "1" = "f12";
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

            # strafing without triggering f3+a
            "a" = "o";
            "d" = "m";

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

            # Keys that produce a character when typed. Rebinding these while the
            # mouse is free (chat/menus) would corrupt what you type, so they only
            # fire when Minecraft has the mouse captured.
            isTypable = key: builtins.match "[a-z0-9]" key != null;

            cursorCapturedCondition = {
              type = "variable_if";
              name = "minecraft_cursor_captured";
              value = 1;
            };

            gameBind = from: to: {
              type = "basic";
              from = (buttonOrKey from) // {
                modifiers.optional = [ "any" ];
              };
              to = [ (buttonOrKey to) ];
              conditions = minecraftConditions ++ lib.optionals (isTypable from) [ cursorCapturedCondition ];
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
              ++ lib.map ({ key, target }: gameBind key target) hmConfig.programs.mcsr.rebind-cycle;
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
