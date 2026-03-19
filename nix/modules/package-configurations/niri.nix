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

    services.swayidle =
      let
        # lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
        lock = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call lockScreen lock";
        display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
        mediaPlaying = "${pkgs.playerctl}/bin/playerctl status 2>/dev/null | ${pkgs.ripgrep}/bin/rg -q Playing";
      in
      {
        enable = true;
        events = {
          # before-sleep = (display "off") + "; " + lock;
          # after-resume = display "on";
          # lock = (display "off") + "; " + lock;
          # unlock = display "on";
        };

        timeouts = [
          {
            timeout = 55;
            command = "${mediaPlaying} || ${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 2000";
          }
          {
            timeout = 60;
            command = "${mediaPlaying} || ${display "off"}";
            resumeCommand = display "on";
          }
          {
            timeout = 125;
            command = "${mediaPlaying} || ${lock}";
          }
          {
            timeout = 135;
            command = "${mediaPlaying} || ${pkgs.systemd}/bin/systemctl suspend";
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
