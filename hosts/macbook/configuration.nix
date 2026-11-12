{ lib, pkgs, ... }:
{
  imports = [
    ../desktop-environment.nix
    ./headphone-keepalive.nix
  ];

  custom.flake-path = "/Users/odilf/code/dotfiles#macbook";

  services.tailscale.enable = true;

  home-manager.users.odilf = {
    programs = {
      # Dev
      alacritty.enable = true;
      fish.enable = true;
      helix.enable = true;
      pi-coding-agent.enable = true;

      git.enable = true;
      jujutsu.enable = true;
      ssh.enable = true;

      # General
      aerc.enable = true;
      khard.enable = true;
      khal.enable = true;
      gurk-rs.enable = true; # signal

      mcsr.enable = true;

      sioyek.enable = true;
    };

    home.packages = [
      pkgs.reaper

      pkgs.libreoffice-bin
      pkgs.obsidian
    ];
  };

  homebrew.casks = [
    "obs"
    "discord"
    "signal"
    "anki"
    "calibre"
    "picard"
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "reaper"
      "obsidian"
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
