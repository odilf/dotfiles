{ config, ... }:
{
  home-manager.users."*" = {
    home.stateVersion = "24.11";
    imports = [
      config.passthru.agenix-hm
    ];

    age = {
      secretsMountPoint = "/tmp/agenix.d";
      secretsDir = "/tmp/agenix";
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "home-manager-backup";
}
