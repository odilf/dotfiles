{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop-environment.hyprland;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  options.desktop-environment.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf (config.gui && cfg.enable && isLinux) {
    programs.hyprland.enable = true;
    programs.waybar.enable = true;
    programs.hyprlock.enable = true;

    services.hypridle.enable = true;

    environment.systemPackages = [
      pkgs.tofi
      pkgs.hyprpaper
    ];

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      # sddm.enable = true;
      # sddm.wayland.enable = true;
    };
  };
}
