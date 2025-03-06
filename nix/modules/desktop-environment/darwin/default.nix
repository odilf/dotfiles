{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  config = lib.mkIf (config.gui && isDarwin) {
    # nix-darwin complains about this
    ids.gids.nixbld = 350;

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
          "/Applications/Firefox Nightly.app"
          "${pkgs.alacritty}/Applications/Alacritty.app"
        ];

        persistent-others = [
          "/Users/odilf/Downloads"
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
      # universalaccess.closeViewScrollWheelToggle = true;
    };

    # TouchID for sudo
    security.pam.services.sudo_local.touchIdAuth = true;

    environment.systemPackages = [
      pkgs.iina # Media player (TODO: should be in something in packages...)
      pkgs.spotify # TODO: Should also be somewhere else
    ];

    # TODO: Remove, replace with kanata
    # services.karabiner-elements.enable = true;

    homebrew = {
      casks = [
        "raycast" # App launcher
        "surfshark" # VPN
        "mechvibes" # cross-platform, but not in nixpkgs...
        "betterdisplay" # macos specific
        "battery" # Keep battery at specific percentage

        # TODO: Remove, replace with kanata
        "karabiner-elements"
      ];
    };

    services = {
      aerospace = {
        enable = true;
        settings =
          # TODO: uggo
          let
            tomlCfg = builtins.fromTOML (builtins.readFile ../../../../aerospace/aerospace.toml);
            cfg = tomlCfg // {
              mode.main.binding = tomlCfg.mode.main.binding // {
                alt-enter = "exec-and-forget open -n ${pkgs.alacritty}/Applications/Alacritty.app";
              };

              # TODO: Do I need to set them explicitly? Or is it only to override them?
              start-at-login = false;
              after-login-command = [ ];
              after-startup-command = [ ];
            };
          in
          cfg;
      };
    };
  };
}
