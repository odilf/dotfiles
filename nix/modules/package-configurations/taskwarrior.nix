{
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{

  home-manager.users."*" =
    { hmConfig, ... }:
    {
      age.secrets.taskwarrior.file = ../../secrets/taskwarrior.age;

      programs.taskwarrior = {
        package = pkgs.taskwarrior3;
        config = {
          confirmation = false;
        };
        extraConfig = "include ${hmConfig.age.secrets.taskwarrior.path}";
      };

      services.taskwarrior-sync = {
        # Enable if taskwarrior is enabled too.
        enable = hmConfig.programs.taskwarrior.enable && isLinux;
        package = pkgs.taskwarrior3;
        frequency = "*:0/5";
      };
    };
}
