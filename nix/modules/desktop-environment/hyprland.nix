{
  config,
  lib,
  pkgs,
  ...
}:
let
  enable = config.gui && config.desktop-environment == "hyprland";
in
{
  config = lib.mkIf enable {
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
