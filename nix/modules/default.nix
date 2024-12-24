{
  lib,
  config,
  ...
}:
{
  imports = [
    ./packages
    ./desktop-environment
    ./peripherals
  ];

  options = {
    gui = lib.mkEnableOption "GUI";
  };

  config = {
    packages.gui = lib.mkDefault config.gui;
  };
}
