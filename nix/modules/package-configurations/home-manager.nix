{ ... }:
{
  home-manager.users."*".home.stateVersion = "24.11";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "home-manager-backup";
}
