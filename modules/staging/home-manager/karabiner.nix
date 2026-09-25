{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  cfg = config.programs.karabiner;
  json = pkgs.formats.json { };
in
{
  options.programs.karabiner = {
    enable = lib.mkEnableOption "Karabiner-Elements configuration";

    profileName = lib.mkOption {
      description = "Name of the active Karabiner profile";
      type = lib.types.str;
      default = "Default profile";
    };

    keyboardType = lib.mkOption {
      description = "Keyboard layout reported by Karabiner's virtual HID keyboard";
      type = lib.types.enum [
        "ansi"
        "iso"
        "jis"
      ];
      default = "iso";
    };

    rules = lib.mkOption {
      description = "Karabiner complex modification rules, keyed by rule name";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            description = lib.mkOption {
              description = "Human-readable description of the rule";
              type = lib.types.str;
            };

            manipulators = lib.mkOption {
              description = "Karabiner manipulators for the rule";
              type = lib.types.listOf lib.types.attrs;
              default = [ ];
            };
          };
        }
      );
      default = { };
      example = {
        caps-lock = {
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
        };
      };
    };

    devices = lib.mkOption {
      description = "Karabiner device configurations, keyed by device name";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            identifiers = lib.mkOption {
              description = "USB identifiers used to match the device";
              type = lib.types.submodule {
                options = {
                  vendor_id = lib.mkOption {
                    description = "USB vendor ID of the device";
                    type = lib.types.ints.u16;
                  };

                  product_id = lib.mkOption {
                    description = "USB product ID of the device";
                    type = lib.types.ints.u16;
                  };

                  is_keyboard = lib.mkOption {
                    description = "Whether the device is a keyboard. Unset to match any device.";
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };

                  is_pointing_device = lib.mkOption {
                    description = "Whether the device is a pointing device. Unset to match any device.";
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                };
              };
            };

            simple_modifications = lib.mkOption {
              description = "Simple key modifications for this device";
              type = lib.types.listOf (
                lib.types.submodule {
                  options = {
                    from = lib.mkOption {
                      description = "Key or button to modify";
                      type = lib.types.attrs;
                    };

                    to = lib.mkOption {
                      description = "Key(s) or button(s) to emit";
                      type = lib.types.listOf lib.types.attrs;
                      default = [ ];
                    };
                  };
                }
              );
              default = [ ];
            };

            ignore = lib.mkOption {
              description = "Whether to ignore this device entirely";
              type = lib.types.bool;
              default = false;
            };

            disable_built_in_keyboard_if_exists = lib.mkOption {
              description = "Whether to disable the built-in keyboard while this device is connected";
              type = lib.types.bool;
              default = false;
            };
          };
        }
      );
      default = { };
      example = {
        "Apple Internal Keyboard" = {
          identifiers = {
            is_keyboard = true;
            vendor_id = 1452;
            product_id = 591;
          };
          simple_modifications = [
            {
              from = {
                key_code = "right_command";
              };
              to = [ { key_code = "right_option"; } ];
            }
          ];
        };
      };
    };
  };

  config = lib.mkIf (isDarwin && cfg.enable) {
    xdg.configFile."karabiner/karabiner.json" = {
      force = true;
      source = json.generate "karabiner.json" {
        profiles = [
          {
            name = cfg.profileName;
            selected = true;
            virtual_hid_keyboard.keyboard_type_v2 = cfg.keyboardType;
            complex_modifications.rules = lib.attrValues cfg.rules;
            devices = map (device: device // {
              identifiers = lib.filterAttrs (_: value: value != null) device.identifiers;
            }) (lib.attrValues cfg.devices);
          }
        ];
      };
    };
  };
}
