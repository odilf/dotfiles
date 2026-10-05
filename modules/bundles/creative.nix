{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86_64;

  enabled = user: config.custom.bundles.${user}.creative.enable;
  enabledForAnyUser = lib.any enabled (builtins.attrNames config.custom.bundles);
in
{
  home-manager.users = lib.mapAttrs (
    user: _:
    lib.mkIf (enabled user) {
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
    }
  ) config.custom.bundles;

  homebrew = lib.mkIf (isDarwin && enabledForAnyUser) {
    casks = [
      "blender"
      "obs"
      "reaper"
      "kdenlive"
    ];
  };
}
