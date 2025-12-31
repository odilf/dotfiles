{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86_64;
in
{
  users.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "social") {
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

          # VST-plugins
          pkgs.lsp-plugins
          pkgs.zam-plugins
        ]
        ++ lib.optionals (isLinux && isx86_64) [
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
