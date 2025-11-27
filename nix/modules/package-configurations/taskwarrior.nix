{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  age.secrets.taskwarrior = {
    file = ../../secrets/taskwarrior.age;
    owner = "odilf";
  };

  home-manager.users."*" = user: {
    programs.taskwarrior = {
      package = pkgs.taskwarrior3;
      config = {
        confirmation = false;
      };
      extraConfig = "include ${config.age.secrets.taskwarrior.path}";
    };

    services.taskwarrior-sync = {
      # Enable if taskwarrior is enabled too.
      enable = config.home-manager.users."${user}".programs.taskwarrior.enable && isLinux;
      package = pkgs.taskwarrior3;
      frequency = "*:0/5";
    };
  };
}
