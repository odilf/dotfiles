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
          # pkgs.musescore
          pkgs.blockbench
          pkgs.blender
        ]
        ++ lib.optionals isLinux [
          pkgs.kdePackages.kdenlive
          pkgs.obs-studio
          pkgs.reaper
        ]
      );
    }
  ) config.custom.bundles;

  homebrew = lib.mkIf (isDarwin && enabledForAnyUser) {
    casks = [
      "blender"
      "obs"
      "kdenlive"
      "reaper"
    ];
  };
}
