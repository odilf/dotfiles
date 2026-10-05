{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86_64;

  utils = import ../utils.nix { inherit config lib pkgs; };
in
{
  home-manager.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "creative") {
      home.packages = lib.optionals config.gui (
        [
          pkgs.musescore
          pkgs.blockbench
          pkgs.blender
        ]
        ++ lib.optionals isLinux [

          pkgs.reaper
          pkgs.kdePackages.kdenlive
          pkgs.obs-studio
          pkgs.ardour

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

  homebrew = lib.mkIf (isDarwin && utils.bundleEnabled "creative") {
    casks = [
      "blender"
      "obs"
      "reaper"
      "kdenlive"
    ];
  };
}
