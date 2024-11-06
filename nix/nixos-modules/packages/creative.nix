{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages.creative;

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  options.packages.creative = {
    enable = lib.mkEnableOption "Packages for creation of art, mostly";

    wacom = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Software to make wacom tablets work";
    };

    # emulators = lib.mkOption {
    #   type = lib.types.bool;
    #   default = true;
    #   description = "Emulators for retro consoles.";
    # };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      [
        # pkgs.reaper # Some problems
      ]
      ++ lib.optionals isLinux ([
        pkgs.blender # broken on darwin
        pkgs.musescore # broken on darwin :cowboy:
        pkgs.obs-studio
      ] ++ lib.optionals cfg.wacom [
        pkgs.wacomtablet
      ]);

    homebrew = lib.mkIf isDarwin {
      casks = [
        "blender"
        "musescore"
        "obs"
      ] ++ lib.optionals cfg.wacom [
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
