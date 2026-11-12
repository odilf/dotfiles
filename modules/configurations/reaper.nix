{
  ...
}:
# TODO: not declaratively configured:
# - most plugins
# - keybinds
# - SWS
#    - superglue
#    - fluent MIDI
{
  home-manager.sharedModules = [
    (
      {
        lib,
        pkgs,
        ...
      }:
      let
        inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86_64;
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

        # TODO: Properly enable reaper
        enabled = false;
        # resourceDir = if isDarwin then "Library/Application Support/REAPER" else ".config/REAPER";
      in
      lib.mkIf enabled {
        # home.linkBunker.files."${resourceDir}" = "live/reaper";
        home.packages = plugins;
      }
    )
  ];
}
