{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
{
  home-manager.users."*" = {
    home.stateVersion = "24.11";
    imports = [
      config.passthru.agenix-hm
    ];

    age =
      lib.mkIf isDarwin {
        secretsMountPoint = "/tmp/agenix.d";
        secretsDir = "/tmp/agenix";
      }
      # TODO: Absolutely horrible :(
      // lib.mkIf isLinux {
        secretsMountPoint = "/run/user/1000/agenix.d";
        secretsDir = "/run/user/1000/agenix";
      };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "home-manager-backup";
}
