{
  lib,
  config,
  ...
}:
{
  imports = [
    ./packages
    ./desktop-environment
    ./home-manager
  ];

  options = {
    gui = lib.mkEnableOption "GUI";
  };

  config = {
    packages.gui = lib.mkDefault config.gui;
  };
}
