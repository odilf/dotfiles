{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  homeConfig = {
    home.stateVersion = "24.11";
    imports = [
      config.passthru.agenix-hm
      ../staging/home-manager
    ];

    home.linkLive.repoPath =
      if config.custom.flake-path == null then
        null
      else
        lib.head (lib.splitString "#" config.custom.flake-path);

    age = lib.mkIf isDarwin {
      secretsMountPoint = "/tmp/agenix.d";
      secretsDir = "/tmp/agenix";
    };
  };
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "home-manager-backup";

  home-manager.sharedModules = [ homeConfig ];
}
