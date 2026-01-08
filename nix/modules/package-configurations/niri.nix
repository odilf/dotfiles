{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.dms-shell.enable = true;
  home-manager.users."*" = lib.mkIf (config.desktop-environment == "niri") {
    programs.fuzzel.enable = true;
    programs.swaylock.enable = true;
    programs.waybar.enable = true;
    services.mako.enable = true;
    services.swayidle.enable = true;
    services.polkit-gnome.enable = true;
    home.packages = [
      pkgs.swaybg
      pkgs.dconf
    ];

    xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "orchis-theme";
        package = pkgs.orchis-theme;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
