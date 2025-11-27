{ config, ... }:
{
  age.secrets.ssh-host-shorthands = {
    file = ../../secrets/ssh-host-shorthands.age;
    owner = "odilf";
  };

  home-manager.users."*" = {
    programs.ssh = {
      enableDefaultConfig = false;
      includes = [
        config.age.secrets.ssh-host-shorthands.path
      ];
    };
  };
}
