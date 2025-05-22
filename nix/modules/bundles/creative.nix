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
  users.users."*" =
    user:
    lib.mkIf (enable user) {
      packages = lib.optionals config.gui (
        [
          pkgs.reaper
          pkgs.cmus
        ]
        ++ lib.optionals isLinux [
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

      # TODO: Same as above
      "wacom-tablet"
    ];

    masApps = lib.mkIf isDarwin {
      "Logic Pro" = 634148309;
    };
  };
}
