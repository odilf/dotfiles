{ ... }:
{
  gui = true;
  desktop-environment = "macOS";

  custom.bundles = {
    odilf = {
      development.enable = true;
      social.enable = true;
      games.enable = true;
      creative.enable = true;
      productivity.enable = true;
    };

    study = {
      development.enable = true;
      productivity.enable = true;
    };
  };

  system.primaryUser = "odilf";

  users.users.odilf = {
    createHome = true;
    home = /Users/odilf;
    description = "Main user";
  };

  users.users.study = {
    createHome = true;
    home = /Users/study;
    description = "User for studying/working";
  };

  # TODO: Maybe do clean uninstall/reinstall thingy... but meh.
  ids.gids.nixbld = 350;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true; # TODO: Make it whitelist, don't allow all

  # TODO: This should be in package-configurations.
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
  system.stateVersion = 5;
}
