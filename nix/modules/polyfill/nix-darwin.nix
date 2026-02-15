{
  lib,
  ...
}:
let
  inherit (import ./util.nix lib) fill;
in
{
  options = {
    fonts.fontconfig = fill;
    console = fill;
    programs = {
      hyprland = fill;
      hyprlock = fill;
      waybar = fill;
      neovim = fill;
      niri = fill;
      localsend = fill;
      xwayland = fill;
    };

    services = {
      hypridle = fill;
      xserver = fill;
      tlp = fill;
      displayManager = fill;
      upower = fill;
    };

    boot = fill;
    hardware = fill;
    networking.networkmanager = fill;
    systemd = fill;
  };
}
