{ ... }:
{
  home-manager.sharedModules = [
    (
      { osConfig, ... }:
      {
        programs.nh = {
          flake = osConfig.custom.flake-path;
          clean = {
            enable = true;
            extraArgs = "--keep 5 --keep-since 3d";
          };
        };
      }
    )
  ];
}
