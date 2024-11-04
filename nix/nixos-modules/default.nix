{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./packages
    ./desktop-environment
  ];

  options = {
    gui = lib.mkEnableOption "GUI";
  };

  config = {
    desktop-environment.enable = lib.mkDefault config.gui;
    packages.gui = lib.mkDefault config.gui;
  };
}
