{ pkgs, ... }:
{
  home-manager.users."*".programs.rofi = {
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
}
