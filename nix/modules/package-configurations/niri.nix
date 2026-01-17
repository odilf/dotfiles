{
  config,
  pkgs,
  lib,
  ...
}:
{
  services = lib.mkIf config.programs.niri.enable {
    displayManager = {
      cosmic-greeter.enable = true;
    };
  };

  home-manager.users."*" = lib.mkIf config.programs.niri.enable {
    home.packages = [
      pkgs.xwayland-satellite
    ];

    xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

    programs.noctalia-shell.enable = true;

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

    services.swayidle = {
      enable = true;
      events.before-sleep = "${pkgs.swaylock}/bin/swaylock";
      timeouts = [
        {
          timeout = 300;
          command = "niri msg action power-off-monitors";
        } # 5min display off
        {
          timeout = 900;
          command = "systemctl suspend";
        } # 15min suspend
      ];
    };

    programs.swaylock = {
      enable = true;
      settings = {
        color = "101010";
      };
    };
  };

}
