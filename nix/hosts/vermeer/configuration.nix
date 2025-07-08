{ pkgs, ... }:
{
  # Just in case.
  environment.packages = [
    pkgs.git
    pkgs.helix
    pkgs.fish
    pkgs.openssh
  ];

  system.stateVersion = "24.05";

  mainUser = "odilf";
  gui = false;
  custom.bundles.odilf = {
    development.enable = true;
    social.enable = false;
    games.enable = false;
    creative.enable = false;
    productivity.enable = false;
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # # TODO: Copied from macbook, should be in package configurations.
  # nix = {
  #   gc.automatic = true;
  #   optimise.automatic = true;
  #   settings = {
  #     experimental-features = [
  #       "nix-command"
  #       "flakes"
  #     ];
  #   };
  # };
}
