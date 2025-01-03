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
    };

    services = {
      hypridle = fill;
      xserver = fill;
    };

    systemd = fill;
  };
}
