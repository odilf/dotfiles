{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.desktop-environment;
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
