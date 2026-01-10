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
      pkgs.quickshell
    ];

    xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

    programs.noctalia-shell.enable = true;

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
  };

}
