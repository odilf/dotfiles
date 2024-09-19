{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  environment.systemPackages = with pkgs; [ 
    bacon
    bat
    bottom
    bun
    btop
    curl
    darwin.trash
    deno
    docker-compose
    dua
    entr
    exiftool
    eza
    fd
    ffmpeg
    fzf
    gcc
    himalaya
    hyperfine
    lima
    mandown
    mosh
    nodejs_22
    pandoc
    pfetch-rs
    pnpm
    python3
    spicetify-cli
    starship
    ripgrep
    rsync
    thefuck
    tokei
    typst
    vim
    neovim
    wget
    yazi
    zellij
    zoxide
    zk
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # TouchID for sudo 
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;


  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  services = {
    skhd.enable = true;
    yabai.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [
      "zackelia/formulae" # For bclm
      "armcord/armcord"
    ];

    brews = [
      "bclm"
    ];

    casks = [
      "accord"
      "alacritty"
      "anki"
      "armcord"
      "bitwarden"
      "cool-retro-term"
      "db-browser-for-sqlite"
      "firefox@nightly"
      "font-geist-mono-nerd-font"
      "font-lora"
      "font-monocraft"
      "inkscape"
      "krita"
      "mechvibes"
      "neovide"
      "steam"
      "telegram"
      "thunderbird"
      "todoist"
      "vscodium"
      "wacom-tablet"
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
