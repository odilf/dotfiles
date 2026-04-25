{
  lib,
  ...
}:
let
  inherit (import ./util.nix lib) fill;
in
{
  options = {
    homebrew = fill;
    security = {
      security.pam.services = fill;
    };

    services = {
      aerospace = fill;
      kanata.kanata-bar = fill;
      kanata.configSource = fill;
    };

    system.defaults = fill;
  };
}
