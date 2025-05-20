{
  lib,
  ...
}:
{
  imports = [
    ./package-configurations
    ./bundles
    ./desktop-environment
  ];

  options = {
    gui = lib.mkEnableOption "Does the system use a graphical user interface?";
  };
}
