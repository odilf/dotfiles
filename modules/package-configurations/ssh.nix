{ ... }:
{
  home-manager.sharedModules = [
    (
      { config, lib, ... }:
      {
        age.secrets = lib.mkIf config.programs.ssh.enable {
          ssh-host-shorthands.file = ../../secrets/ssh-host-shorthands.age;
        };

        programs.ssh = {
          enableDefaultConfig = false;
          includes = [
            config.age.secrets.ssh-host-shorthands.path
          ];
        };
      }
    )
  ];
}
