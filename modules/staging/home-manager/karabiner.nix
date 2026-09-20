{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  cfg = config.programs.karabiner;
in
{
  options.programs.karabiner = {
    enable = lib.mkEnableOption "Karabiner-Elements configuration";

    rules = lib.mkOption {
      description = "Karabiner complex modification rules";
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
    };

    devices = lib.mkOption {
      description = "Karabiner device configurations";
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
    };
  };

  config = lib.mkIf (isDarwin && cfg.enable) {
    xdg.configFile."karabiner/karabiner.json" = {
      force = true;
      text = builtins.toJSON {
        profiles = [
          {
            name = "Default profile";
            selected = true;
            virtual_hid_keyboard.keyboard_type_v2 = "iso";
            complex_modifications.rules = cfg.rules;
            inherit (cfg) devices;
          }
        ];
      };
    };
  };
}
