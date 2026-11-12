{ lib, pkgs, ... }:
{
  imports = [ ./headphone-keepalive.nix ];

  gui = true;

  custom = {
    flake-path = "/Users/odilf/code/dotfiles#macbook";
    bundles = {
      odilf = {
        development.enable = true;
        social.enable = true;
        productivity.enable = true;
      };
    };
  };

  home-manager.users.odilf = {
    programs = {
      aerc.enable = true;
      khard.enable = true;
      khal.enable = true;
      gurk-rs.enable = true; # signal

      mcsr.enable = true;
    };

    home.packages = [
      pkgs.obs-studio
      pkgs.reaper
    ];
  };

  homebrew.casks = [
    "discord"
    "signal"
  ];

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

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
