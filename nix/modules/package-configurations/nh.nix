{ config, ... }:
{
  home-manager.users."*" = {
    programs.nh = {
      flake = config.custom.flake-path;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };
  };
}
