{ lib, config, ... }:
let
  root = path: ../../../. + path;
in
{
  imports =
    [
    ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.odilf = {
    # home.file.".config/karabiner".source = ../../../karabiner;
    # home.file.".config/nvim".source = ../../../nvim;
    home.stateVersion = "24.11";
  };
}
