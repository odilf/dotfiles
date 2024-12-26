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
    ./laptop
  ];

  options = {
    gui = lib.mkEnableOption "the graphical user interface";
  };

  config = {
    packages.gui = lib.mkDefault config.gui;
  };
}
