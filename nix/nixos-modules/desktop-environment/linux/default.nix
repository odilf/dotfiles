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
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  config = {
    desktop-environment.gnome.enable = lib.mkDefault true;
  };
}
