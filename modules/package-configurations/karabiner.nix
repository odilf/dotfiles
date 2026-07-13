{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  tabArrow = dir: key: {
    type = "basic";
    from = {
      key_code = key;
      modifiers.optional = [ "any" ];
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
      disable_built_in_keyboard_if_exists = true;
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
