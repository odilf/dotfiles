{
  pkgs,
  lib,
  config,
  ...
}:
let
  utils = import ../utils.nix { inherit lib pkgs config; };
in
{
  imports = [
    ./syncthing.nix
  ];

  config =
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "home-manager-backup";
    }
    // utils.eachHome {
      home.stateVersion = "24.11";
    };
}
