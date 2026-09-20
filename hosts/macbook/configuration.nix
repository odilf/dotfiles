{ ... }:
{
  gui = true;
  desktop-environment = "macOS";

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

  home-manager.users.odilf.programs.mcsr = {
    enable = true;
    standardsettings = {
      Ranked = ./mcsr/standardsettings/ranked.json;
      "Ranked Practice" = ./mcsr/standardsettings/ranked-practice.json;
      Speedrunning = ./mcsr/standardsettings/speedrunning.json;
    };
  };

  system.primaryUser = "odilf";

  users.users.odilf = {
    createHome = true;
    home = /Users/odilf;
    description = "Main user";
  };

  # TODO: Maybe do clean uninstall/reinstall thingy... but meh.
  ids.gids.nixbld = 350;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
