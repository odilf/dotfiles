{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  nonCmdModifiers = [
    "shift"
    "control"
    "option"
    "fn"
    "caps_lock"
  ];

  tabArrow = dir: key: {
    type = "basic";
    from = {
      key_code = key;
      modifiers.optional = nonCmdModifiers;
    };
    to = [ { key_code = "${dir}_arrow"; } ];
    conditions = [
      {
        type = "variable_if";
        name = "tab_layer_active";
        value = 1;
      }
    ];
  };

  tabCondition = value: {
    type = "variable_if";
    name = "tab_layer_active";
    value = value;
  };

  minecraftDisabledCondition = value: {
    type = "variable_if";
    name = "minecraft_hotkeys_disabled";
    value = value;
  };

  focusCmdKey = { key_code, fkey }: {
    type = "basic";
    from = {
      key_code = key_code;
      modifiers.mandatory = [ "command" ];
    };
    to = [
      {
        key_code = fkey;
        modifiers = [ "command" ];
      }
    ];
    conditions = [ (tabCondition 0) ];
  };

  externalKeyboard =
    {
      vendor_id,
      product_id,
      simple_modifications ? [ ],
    }:
    {
      identifiers = {
        is_keyboard = true;
        inherit vendor_id product_id;
      };
      inherit simple_modifications;
    };

  isoSwap = [
    {
      from.key_code = "grave_accent_and_tilde";
      to = [ { key_code = "non_us_backslash"; } ];
    }
    {
      from.key_code = "non_us_backslash";
      to = [ { key_code = "grave_accent_and_tilde"; } ];
    }
  ];

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

  karabinerConfig = {
    profiles = [
      {
        name = "Default profile";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "iso";
        complex_modifications.rules = [
          {
            description = "Ctrl + Left Click to Left Click";
            manipulators = [
              {
                type = "basic";
                from = {
                  pointing_button = "button1";
                  modifiers = {
                    mandatory = [ "left_control" ];
                    optional = [ "caps_lock" ];
                  };
                };
                to = [
                  { pointing_button = "button1"; }
                  { key_code = "left_control"; }
                ];
              }
            ];
          }
          {
            description = "Caps Lock to Esc (tap) / Left Ctrl (hold)";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "caps_lock";
                  modifiers.optional = [ "any" ];
                };
                to = [ { key_code = "left_control"; } ];
                to_if_alone = [ { key_code = "escape"; } ];
              }
            ];
          }
          {
            description = "Cmd+hjkl (no tab) = AeroSpace focus (cmd+f13..f16)";
            manipulators = [
              (focusCmdKey {
                key_code = "h";
                fkey = "f13";
              })
              (focusCmdKey {
                key_code = "j";
                fkey = "f14";
              })
              (focusCmdKey {
                key_code = "k";
                fkey = "f15";
              })
              (focusCmdKey {
                key_code = "l";
                fkey = "f16";
              })
            ];
          }
          {
            description = "Tab held = arrow layer (h/j/k/l)";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "tab";
                  modifiers.optional = [ "any" ];
                };
                to = [
                  {
                    set_variable = {
                      name = "tab_layer_active";
                      value = 1;
                    };
                  }
                ];
                to_if_alone = [ { key_code = "tab"; } ];
                to_after_key_up = [
                  {
                    set_variable = {
                      name = "tab_layer_active";
                      value = 0;
                    };
                  }
                ];
              }
              (tabArrow "left" "h")
              (tabArrow "down" "j")
              (tabArrow "up" "k")
              (tabArrow "right" "l")
            ];
          }
          {
            description = "Toggle Minecraft / SlackowWall hotkeys (Fn+M)";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "m";
                  modifiers.mandatory = [ "fn" ];
                };
                to = [
                  {
                    set_variable = {
                      name = "minecraft_hotkeys_disabled";
                      value = 1;
                    };
                  }
                ];
                conditions = [ (minecraftDisabledCondition 0) ];
              }
              {
                type = "basic";
                from = {
                  key_code = "m";
                  modifiers.mandatory = [ "fn" ];
                };
                to = [
                  {
                    set_variable = {
                      name = "minecraft_hotkeys_disabled";
                      value = 0;
                    };
                  }
                ];
                conditions = [ (minecraftDisabledCondition 1) ];
              }
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

        # Add new external keyboards here with their vendor_id and product_id.
        # `disable_built_in_keyboard_if_exists` is set automatically.
        devices = [
          # Apple Internal Keyboard
          (externalKeyboard {
            vendor_id = 1452;
            product_id = 591;
            simple_modifications = isoSwap ++ [
              {
                from.key_code = "right_command";
                to = [ { key_code = "right_option"; } ];
              }
            ];
          })

          # Keychron K2
          (externalKeyboard {
            vendor_id = 76;
            product_id = 332;
            simple_modifications = isoSwap;
          })

          # Other
          (externalKeyboard {
            vendor_id = 1133;
            product_id = 45081;
            simple_modifications = isoSwap;
          })
        ];
      }
    ];
  };
in
{
  home-manager.users."*" = lib.mkIf isDarwin {
    xdg.configFile."karabiner/karabiner.json" = {
      text = builtins.toJSON karabinerConfig;
      force = true;
    };
  };
}
