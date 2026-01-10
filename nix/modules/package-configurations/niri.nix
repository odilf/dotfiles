{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.displayManager = lib.mkIf config.programs.niri.enable {
    cosmic-greeter.enable = true;
  };

  home-manager.users."*" = lib.mkIf config.programs.niri.enable {
    home.packages = [
      pkgs.quickshell
    ];

    xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

    programs.noctalia-shell.enable = true;
  };
}
