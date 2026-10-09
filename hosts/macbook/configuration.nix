{ ... }:
{
  gui = true;

  custom = {
    flake-path = "/Users/odilf/code/dotfiles#macbook";
    bundles = {
      odilf = {
        development.enable = true;
        social.enable = true;
        games.enable = true;
        creative.enable = true;
        productivity.enable = true;
      };
    };
  };

  system.primaryUser = "odilf";

  users = {
    # Account settings below (uid, home, login shell) are owned by this config only for listed users.
    knownUsers = [ "odilf" ];

    users.odilf = {
      createHome = true;
      home = "/Users/odilf";
      description = "Main user";
      uid = 501;
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
