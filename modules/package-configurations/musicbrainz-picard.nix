{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  utils = import ../utils.nix { inherit config lib pkgs; };
in
{
  home-manager.users."*" =
    { user, ... }:
    {
      home.linkLive.files =
        lib.mkIf
          (
            utils.packageInstalled pkgs.picard user
            || (isDarwin && builtins.elem "musicbrainz-picard" config.homebrew.casks)
          )
          {
            ".config/MusicBrainz" = "live/picard";
          };
    };
}
