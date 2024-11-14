{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop-environment.gnome;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  options.desktop-environment.gnome = {
    enable = lib.mkEnableOption "gnome";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
