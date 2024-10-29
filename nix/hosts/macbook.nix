{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  environment.systemPackages = with pkgs; [
    deno # For peek.nvim
    exiftool
    imagemagick
    lima
    mosh
    sketchybar
  ];

  environment.variables = {
    SHELL = "fish";
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
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

  # TouchID for sudo 
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [
      "armcord/armcord" # For armcord
      "zackelia/formulae" # For bclm
      "nikitabobko/tap" # For aerospace
      "FelixKratz/formulae" # For JankyBorders
    ];

    brews = [
      "bclm"
      "bitwarden-cli"
      "borders"
    ];

    casks = [
      "accord"
      "aerospace"
      "alacritty"
      "anki"
      "armcord"
      "bitwarden"
      "cool-retro-term"
      "db-browser-for-sqlite"
      "epic-games"
      "firefox@nightly"
      "font-lora"
      "font-0xproto-nerd-font"
      "font-comic-shanns-mono-nerd-font"
      "font-monocraft-nerd-font"
      "font-geist-mono-nerd-font"
      "font-zed-mono-nerd-font"
      "inkscape"
      "krita"
      "mechvibes"
      "microsoft-teams" # sigh...
      "minecraft"
      "neovide"
      "steam"
      "surfshark" # Maybe delete
      "telegram" # Mayeb delete
      "todoist"
      "vscodium"
      "wacom-tablet"
    ];
  };

  # Install Rosetta 2 for compatibility with x86_64 binaries.
  # system.activationScripts.extraActivation.text = ''
  #   softwareupdate --install-rosetta --agree-to-license
  # '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
