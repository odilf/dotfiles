{ ... }:
{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        programs.rofi = {
          plugins = [
            pkgs.rofi-calc
            pkgs.rofi-emoji
          ];

          settings.modes = [
            "window"
            "run"
            "drun"
            "ssh"
            "filebrowser"
            "emoji"
            "calc"
          ];
        };
      }
    )
  ];
}
