{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.desktop-environment;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  # options.desktop-environment = {
  #
  # };

  config = {
    environment.systemPackages =
      [
      ];

    homebrew = {
      casks = [ ];
    };
  };
}
