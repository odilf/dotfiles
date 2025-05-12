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

    vst-plugins = lib.mkEnableOption "Add VST plugins for music production and tinkering";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      [
        pkgs.reaper
        pkgs.cmus
      ]
      ++ lib.optionals isLinux (
        [
          pkgs.blender
          pkgs.musescore
          pkgs.obs-studio
          pkgs.ardour
          pkgs.lmms
        ]
        ++ lib.optionals cfg.wacom [
          pkgs.wacomtablet
        ]
      )
      ++ lib.optionals cfg.vst-plugins (
        [
        ]
        ++ lib.optionals isLinux [
          pkgs.lsp-plugins
          pkgs.zam-plugins
          pkgs.surge
          pkgs.oxefmsynth
        ]

      );

    homebrew = lib.mkIf isDarwin {
      casks =
        [
          "blender"
          "musescore"
          "obs"
          # Ardour is not on brew (nor nixpkgs for darwin)...
          # "ardour"
          "lmms"
        ]
        ++ lib.optionals cfg.wacom [
          "wacom-tablet"
        ];

      masApps = lib.mkIf isDarwin {
        # "Logic Pro" = 634148309;
      };
    };
  };
}
