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
      pam.services.sudo_local.touchIdAuth = fill;
    };

    services = {
      aerospace = fill;
    };

    system.defaults = fill;
  };
}
