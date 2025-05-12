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
  config = lib.recursiveUpdate (utils.eachHome { home.stateVersion = "24.11"; }) {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "home-manager-backup";
  };
}
