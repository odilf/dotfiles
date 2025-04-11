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
    };

    system.defaults = fill;
  };
}
