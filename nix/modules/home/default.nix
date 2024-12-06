{ pkgs, lib, config, ... }:
let
  utils = import ../utils.nix { inherit lib pkgs config; };
in
{
  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  } // utils.eachHome {
    home.stateVersion = "24.11";
  };
}
