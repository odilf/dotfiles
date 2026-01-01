{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  pkg = pkgs.taskwarrior3;
in
{

  home-manager.users."*" =
    { hmConfig, ... }:
    {
      age.secrets.taskwarrior.file = ../../secrets/taskwarrior.age;

      programs.taskwarrior = {
        package = pkg;
        config = {
          confirmation = false;
        };
        extraConfig = "include ${hmConfig.age.secrets.taskwarrior.path}";
      };

      # Sync hook
      home.file."${hmConfig.xdg.dataHome}/task/hooks/on-exit-sync" = {
        text = ''
          ${lib.getExe pkg} sync > /dev/null 2>&1 &
          exit 0
        '';
        executable = true;
      };

      services.taskwarrior-sync = {
        enable = hmConfig.programs.taskwarrior.enable && isLinux;
        package = pkg;
        frequency = "*:0/5";
      };
    };
}
