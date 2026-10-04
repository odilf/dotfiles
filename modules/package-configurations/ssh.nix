{
  lib,
  ...
}:
{
  home-manager.users."*" =
    { hmConfig, ... }:
    lib.mkIf hmConfig.programs.ssh.enable {
      age.secrets.ssh-host-shorthands.file = ../../secrets/ssh-host-shorthands.age;
      programs.ssh = {
        enableDefaultConfig = false;
        includes = [
          hmConfig.age.secrets.ssh-host-shorthands.path
        ];
      };
    };
}
