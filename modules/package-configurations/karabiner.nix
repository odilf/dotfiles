{ ... }:
let
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

  # Karabiner does not modify pointing devices by default. A device must be
  # listed here for pointing-button complex modifications to take effect.
  externalPointingDevice =
    {
      vendor_id,
      product_id,
      simple_modifications ? [ ],
    }:
    {
      identifiers = {
        is_pointing_device = true;
        inherit vendor_id product_id;
      };
      ignore = false;
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
in
{
  custom.karabiner = {
    enable = true;

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

      # Mouse (enables pointing-button modifications, e.g. button4 -> F3)
      (externalPointingDevice {
        vendor_id = 7511;
        product_id = 44311;
      })
    ];

    rules = [
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
    ];
  };
}
