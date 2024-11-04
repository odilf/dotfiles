# TODO
# - [ ] Emulators
# - [ ] Steam
# - [ ] Epic games
# - [ ] Terminal games

{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages.games;
in
{
  options.games = {
    enable = lib.mkEnableOption "Packages for gaming";

    emulators = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Emulators for retro consoles.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment =
      {
      };
  };
}
