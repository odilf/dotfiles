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
    };

    services = {
      hypridle = fill;
      xserver = fill;
      tlp = fill;
    };

    systemd = fill;

    fileSystems = fill;
  };
}
