{ ... }:
{
  gui = true;

  packages = {
    users = [ "study" ];
    development.enable = true;
    productivity.enable = true;

    social.enable = false;
    games.enable = false;
    creative.enable = false;
    creative.wacom = false;
  };

  users.users.study = {
    home = "/Users/study";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true; # TODO: Make it whitelist, don't allow all

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
