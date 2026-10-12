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
    let
      # TODO: This should be in `reaper.nix`, but it leads to an infinite
      # recursion error because we try to check if reaper is in `pacakges`
      # and then try to add more packages.
      plugins =
        lib.optionals isLinux [
          pkgs.lsp-plugins
          pkgs.zam-plugins
        ]
        ++ lib.optionals (isLinux && isx86_64) [
          pkgs.surge
          pkgs.oxefmsynth
        ]
        ++ lib.optionals isDarwin [
          pkgs.lsp-plugins-macos
        ];
    in
    lib.mkIf (enabled user) {
      home.packages = lib.optionals config.gui (
        [
          pkgs.musescore
          pkgs.blockbench
          pkgs.blender
        ]
        ++ lib.optionals isLinux [
          pkgs.kdePackages.kdenlive
          pkgs.obs-studio
          pkgs.reaper
        ]
        ++ plugins
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
