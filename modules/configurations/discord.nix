{ ... }:
{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (pkgs.stdenv.hostPlatform) isDarwin;
      in
      {
        # macos doesn't like modifying Application Support, and regardless the
        # config file has basically nothing.
        config = lib.mkIf (isDarwin && config.programs.discord.enable) {
          home.file."Library/Application Support/discord/settings.json".enable = false;
          home.file.".config/discord/settings.json".source =
            config.home.file."Library/Application Support/discord/settings.json".source;
        };
      }
    )
  ];
}
