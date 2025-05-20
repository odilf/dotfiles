{
  config,
  lib,
  ...
}:
let
  enabled = config.desktop-environment == "gnome";
in
{
  config = lib.mkIf enabled {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
