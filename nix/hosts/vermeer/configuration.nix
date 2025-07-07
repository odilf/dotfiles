{ pkgs, ... }:
{
  environment.packages = [
    pkgs.git
    pkgs.helix
    pkgs.fish
  ];

  user.shell = "${pkgs.fish}/bin/fish";
  system.stateVersion = "24.05";
  # gui = true;
  # desktop-environment = "macOS";

  # custom.bundles.odilf = {
  #   development.enable = true;
  #   social.enable = false;
  #   games.enable = false;
  #   creative.enable = false;
  #   productivity.enable = false;
  # };

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
