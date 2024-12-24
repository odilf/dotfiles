{
  lib,
  config,
  ...
}:
{
  imports = [
    ./packages
    ./desktop-environment
    ./home
    ./peripherals
  ];

  options = {
    gui = lib.mkEnableOption "the graphical user interface";
  };

  config = {
    packages.gui = lib.mkDefault config.gui;
  };
}
