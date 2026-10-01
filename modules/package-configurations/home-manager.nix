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
      ../staging/home-manager
    ];

    home.linkLive.repoPath =
      if config.custom.flake-path == null then null else lib.head (lib.splitString "#" config.custom.flake-path);

    age = lib.mkIf isDarwin {
      secretsMountPoint = "/tmp/agenix.d";
      secretsDir = "/tmp/agenix";
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "home-manager-backup";
}
