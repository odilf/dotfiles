{
  pkgs,
  lib,
  config,
  ...
}:
let
  enabled = config.gui && config.desktop-environment == "macOS";
  utils = import ../utils.nix { inherit config lib pkgs; };
in
{
  config = lib.mkIf enabled {
    system.defaults = {
      ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
      NSGlobalDomain.AppleKeyboardUIMode = 3;
      NSGlobalDomain.ApplePressAndHoldEnabled = false;
      NSGlobalDomain.AppleShowAllExtensions = true;
      NSGlobalDomain.AppleShowAllFiles = true;

      NSGlobalDomain.KeyRepeat = 1;
      NSGlobalDomain.InitialKeyRepeat = 10;

      NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
      NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
      NSGlobalDomain.NSTableViewDefaultSizeMode = 2; # Size of Finder sidebar icons

      NSGlobalDomain."com.apple.keyboard.fnState" = true; # Use F1, F2, etc as function keys

      controlcenter = {
        AirDrop = false;
        BatteryShowPercentage = true;
        Bluetooth = false;
        Display = false;
        FocusModes = false;
        NowPlaying = true;
        Sound = false;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.3;

        largesize = 68;
        magnification = true;
        mineffect = "suck";
        mru-spaces = false;

        orientation = "right";

        persistent-apps = [
          "${pkgs.firefox-beta}/Applications/Firefox Beta.app"
          "${pkgs.alacritty}/Applications/Alacritty.app"
        ];

        persistent-others = [
          "~/Downloads"
        ];

        show-recents = false;
        showhidden = true; # Translucent hidden icons

        tilesize = 64;

        # Disable hot corners
        # TODO: Maybe enable them?
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };

      finder = {
        # TODO: Isn't this redundant with the things above?
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;

        FXDefaultSearchScope = "SCcf"; # When searching, use current folder (instead of "This Mac")
        FXPreferredViewStyle = "clmv"; # Default to column view

        QuitMenuItem = true; # Allow quitting Finder
        ShowPathbar = true; # Show path breadcrumbs in finder windows
        ShowStatusBar = true; # Show status bar at bottom of finder windows with item/disk space stats
      };

      # Login thing
      loginwindow.GuestEnabled = true;
      loginwindow.LoginwindowText = "Yo.";

      screencapture.location = "~/Downloads";
      screencapture.type = "jpg";

      # TODO: Doesn't work: `Could not write domain com.apple.universalaccess; exiting`
      # Zoom thingy with ^ (control).
      # https://github.com/nix-darwin/nix-darwin/issues/1049?
      #universalaccess.closeViewScrollWheelToggle = true;
    };

    # TouchID for sudo
    security.pam.services.sudo_local.touchIdAuth = true;

    homebrew = {
      onActivation.cleanup = "zap";
      brews = lib.traceVal [
        "batt" # Keep battery at specific percentage
      ];

      casks = [
        "raycast" # App launcher
        "mechvibes" # cross-platform, but not in nixpkgs...
        "betterdisplay" # macos specific

        # TODO: Remove, replace with kanata
        "karabiner-elements"
      ];
    };

    # home-manager.users."*".programs = {
    #   aerospace.enable = true;
    #   firefox.enable = true;
    # };

    home-manager.users = utils.mapUsers (username: {
      programs.aerospace.enable = true;
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-beta;
      };
    });
  };
}
