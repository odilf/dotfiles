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
        config,
        lib,
        pkgs,
        ...
      }:
      # let
      #   inherit (pkgs.stdenv.hostPlatform) isDarwin;
      #    resourceDir = if isDarwin then "Library/Application Support/REAPER" else ".config/REAPER";
      # in
      lib.mkIf (builtins.elem pkgs.reaper config.home.packages) {
        # home.linkLive.files."${resourceDir}" = "live/reaper";
      }
    )
  ];
}
