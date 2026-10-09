{ ... }:
{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        osConfig,
        ...
      }:
      let
        inherit (pkgs.stdenv.hostPlatform) isDarwin;
      in
      {
        home.linkLive.files =
          lib.mkIf
            (
              builtins.elem pkgs.picard config.home.packages
              || (isDarwin && builtins.elem "musicbrainz-picard" osConfig.homebrew.casks)
            )
            {
              ".config/MusicBrainz" = "live/picard";
            };
      }
    )
  ];
}
