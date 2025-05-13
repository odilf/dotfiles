{
  pkgs,
  lib,
  config,
  ...
}:
let
  utils = import ../../utils.nix;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  config =
    lib.mkIf (config.gui && isDarwin) {
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

      # services.aerospace = ;
    }
    // utils.eachHome {
      services.aerospace = {
        enable = true;
        settings = {
          # If I ever want to use sketchybar again:
          # after-startup-command = [
          # 	'exec-and-forget borders active_color=0xffffff inactive_color=0x000000 width=10.0 style=round',
          # 	'exec-and-forget sketchybar'
          # ]
          # exec-on-workspace-change = ['/bin/bash', '-c',
          #     'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE'
          # ]

          # I think this should not be necessary:
          accordion-padding = 30;

          mode.main.binding = {
            alt-enter = "exec-and-forget open -n ${pkgs.alacritty}/Applications/Alacritty.app";
            alt-shift-enter = "exec-and-forget open -n /Applications/Firefox Nightly.app";

            # See: https://nikitabobko.github.io/AeroSpace/commands#layout
            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";

            # See: https://nikitabobko.github.io/AeroSpace/commands#focus
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#move
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            alt-shift-ctrl-h = "join-with left";
            alt-shift-ctrl-j = "join-with down";
            alt-shift-ctrl-k = "join-with up";
            alt-shift-ctrl-l = "join-with right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#resize
            alt-shift-minus = "resize smart -50";
            alt-shift-equal = "resize smart +50";

            # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
            ctrl-1 = "workspace 1";
            ctrl-2 = "workspace 2";
            ctrl-3 = "workspace 3";
            ctrl-4 = "workspace 4";
            ctrl-5 = "workspace 5";
            ctrl-6 = "workspace 6";
            ctrl-7 = "workspace 7";
            ctrl-8 = "workspace 8";
            ctrl-9 = "workspace 9";

            # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
            alt-shift-1 = "move-node-to-workspace 1";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-shift-5 = "move-node-to-workspace 5";
            alt-shift-6 = "move-node-to-workspace 6";
            alt-shift-7 = "move-node-to-workspace 7";
            alt-shift-8 = "move-node-to-workspace 8";
            alt-shift-9 = "move-node-to-workspace 9";

            alt-f = "fullscreen";

            # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
            alt-tab = "workspace-back-and-forth";
            # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
          };
        };
      };
    };
}
