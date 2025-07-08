{
  lib,
  config,
  ...
}:
let
  fill = (import ./util.nix lib).fill-allow;
in
{
  options = {
    mainUser = lib.mkOption {
      type = lib.types.str;
      description = "Main user, used to get their config from the per-user configs";
    };
    environment.systemPackages = fill;
    environment.variables = fill;
    environment.pathsToLink = fill;
    programs = fill;
    fonts = fill;
    services = fill;
    systemd = fill;

    homebrew = fill;
    security = fill;
    system.defaults = fill;
    users = fill;

    home-manager.users = fill;
  };

  config = {
    environment.packages = config.users.users."${config.mainUser}".packages;
    environment.sessionVariables = config.environment.variables;
    home-manager.config = config.home-manager.users."${config.mainUser}";
    home-manager.users."${config.mainUser}".home.homeDirectory = config.user.home;
    user.shell = "${lib.getExe config.users.users."${config.mainUser}".shell}";
  };
}
