{ pkgs, ... }:
{
  gui = true;

  packages = {
    users = [ "odilf" ];
    social.enable = true;
    games.enable = true;
    creative.enable = true;
    creative.wacom = true;
  };

  users.users.odilf = {
    home = "/Users/odilf";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true; # TODO: Make it whitelist, don't allow all

  services.nix-daemon.enable = true;
  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
