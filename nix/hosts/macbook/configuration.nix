{ pkgs, ... }:
{
  gui = true;

  packages = {
    social.enable = true;
    games.enable = true;
    creative.enable = true;
    creative.wacom = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true; # TODO: Make it whitelist, don't allow all

  environment.systemPackages = with pkgs; [
    deno # For peek.nvim
    nodejs_latest # For copilot.nvim
  ];

  services.nix-daemon.enable = true;
  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
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
