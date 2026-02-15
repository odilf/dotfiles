{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  enable = isLinux && config.programs.niri.enable;
in
{
  services = lib.mkIf enable {
    displayManager = {
      cosmic-greeter.enable = true;
    };
  };

  home-manager.users."*" = lib.mkIf enable {
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

    services.swayidle =
      let
        lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
        display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
      in
      {
        enable = true;
        events = {
          before-sleep = (display "off") + "; " + lock;
          after-resume = display "on";
          lock = (display "off") + "; " + lock;
          unlock = display "on";
        };

        timeouts = [
          {
            timeout = 55;
            command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 2000";
          }
          {
            timeout = 60;
            command = display "off";
            resumeCommand = display "on";
          }
          {
            timeout = 125;
            command = lock;
          }
          {
            timeout = 135;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };

    programs.swaylock = {
      enable = true;
      settings = {
        color = "101010";
      };
    };

    programs.rofi = {
      enable = true;
      plugins = [
        pkgs.rofi-calc
        pkgs.rofi-emoji
      ];

      modes = [
        "window"
        "run"
        "drun"
        "ssh"
        "filebrowser"
        "emoji"
        "calc"
      ];
    };
  };

}
