{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages.creative;

  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  options.packages.creative = {
    enable = lib.mkEnableOption "Packages for creation of art, mostly";

    wacom = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Software to make wacom tablets work";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      [
        pkgs.reaper
      ]
      ++ lib.optionals isLinux (
        [
          pkgs.blender
          pkgs.musescore
          pkgs.obs-studio
        ]
        ++ lib.optionals cfg.wacom [
          pkgs.wacomtablet
        ]
      );

    homebrew = lib.mkIf isDarwin {
      casks =
        [
          "blender"
          "musescore"
          "obs"
        ]
        ++ lib.optionals cfg.wacom [
          "wacom-tablet"
        ];

      masApps = lib.mkIf isDarwin {
        "Logic Pro" = 634148309;
        # - [ ] Facetime
        # - [ ] Safari i guess for testing
        # - [ ] Photos
      };
    };
  };
}
