{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  enable = isLinux && config.programs.niri.enable;

  homeConfig =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.xwayland-satellite
      ];

      home.linkLive.files.".config/niri" = "live/niri";

      programs.noctalia.enable = true;
      programs.tofi.enable = true;

      programs.swaylock = {
        enable = true;
        settings = {
          color = "101010";
        };
      };

      services.swayidle =
        let
          lock = "${pkgs.swaylock}/bin/swaylock -f";
          display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
          mediaPlaying = "${pkgs.playerctl}/bin/playerctl status 2>/dev/null | ${pkgs.ripgrep}/bin/rg -q Playing";
        in
        {
          enable = true;
          events = {
            inherit lock;
            before-sleep = lock;
            after-resume = display "on";
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
    };
in
{
  services = lib.mkIf enable {
    displayManager.ly.enable = true;
    niri-session-manager.enable = true;
    # The power button is bound in live/niri/config.kdl; logind must not act on it.
    logind.settings.Login.HandlePowerKey = "ignore";
  };

  home-manager.sharedModules = lib.mkIf enable [ homeConfig ];
}
