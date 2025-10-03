{
  config,
  pkgs,
  lib,
  ...
}:
{
  home-manager.users."*" = lib.mkIf (config.desktop-environment == "niri") {
    programs.fuzzel.enable = true;
    programs.swaylock.enable = true;
    programs.waybar.enable = true;
    services.mako.enable = true;
    services.swayidle.enable = true;
    services.polkit-gnome.enable = true;
    home.packages = with pkgs; [
      swaybg
    ];

    xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
  };
}
