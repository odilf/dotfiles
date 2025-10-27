{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  enable = user: config.custom.bundles."${user}".social.enable;
in
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "reaper"
    ];

  users.users."*" =
    user:
    lib.mkIf (enable user) {
      packages = lib.optionals config.gui (
        [
        ]
        ++ lib.optionals isLinux [
          # TODO: Mirrors dont' seem to work for darwin...
          pkgs.blockbench

          pkgs.reaper
          pkgs.blender
          pkgs.musescore
          pkgs.obs-studio

          # Wacom tablet drivers thingy
          # TODO: Maybe this should go in peripherals...
          pkgs.wacomtablet

          # VST-plugins
          pkgs.lsp-plugins
          pkgs.zam-plugins
          pkgs.surge
          pkgs.oxefmsynth
        ]
      );
    };

  homebrew = lib.mkIf isDarwin {
    casks = [
      "blender"
      "musescore"
      "obs"

      "reaper"

      # TODO: Same as above
      "wacom-tablet"
      "blockbench"
    ];

    # NOTE: Better to just install manually...
    # masApps = lib.mkIf isDarwin {
    #   "Logic Pro" = 634148309;
    # };
  };
}
