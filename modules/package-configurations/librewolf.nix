{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  addons = pkgs.firefox-addons;
in
{
  home-manager.users."*" = {
    programs.librewolf = {
      package = lib.mkIf isLinux pkgs.librewolf-bin;
      settings = {
        # Startup & UI
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.tabs.warnOnClose" = true;
        "browser.startup.page" = 3;
        "findbar.highlightAll" = true;

        # New tab, downloads, updates, media
        "browser.newtabpage.enabled" = false;
        "browser.download.useDownloadDir" = true;
        "extensions.update.enabled" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

        # Losing the bargain
        "privacy.resistFingerprinting" = false;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC";

        # Sidebery
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "sidebar.revamp.round-content-area" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      policies = {
        # Updates & Background Services
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;

        # Feature Disabling
        DisableBuiltinPDFViewer = true;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableForgetButton = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisablePasswordReveal = true;

        # Access Restrictions
        BlockAboutConfig = false;
        BlockAboutProfiles = true;
        BlockAboutSupport = true;

        # UI and Behavior
        DisplayMenuBar = "never";
        OfferToSaveLogins = false;
      };

      profiles =
        let
          common = {
            userChrome = builtins.readFile ./librewolf/sidebery.css;
            settings = {
              "extensions.autoDisableScopes" = 0;
              "extensions.startupScanScopes" = 15; # profile|user|application|system
            };

            extensions.packages = [
              addons.bitwarden
              addons.clearurls
              addons.darkreader
              addons.leechblock-ng
              addons.sidebery
              addons.simple-translate
              addons.tab-volume-control
              addons.tridactyl
              addons.ublock-origin
            ];

            extensions.settings = {
              "${addons.sidebery.addonId}" = {
                force = true;
                settings = {
                  settings = {
                    "switch_to_panel_0" = "Alt+1";
                    "switch_to_panel_1" = "Alt+2";
                    "switch_to_panel_2" = "Alt+3";
                    "switch_to_panel_3" = "Alt+4";
                    "animationSpeed" = "fast";
                    "autoCloseBookmarks" = true;
                    "autoExpandTabs" = true;
                    "autoFoldTabs" = true;
                    "colorizeTabs" = true;
                    "colorizeTabsBranches" = true;
                    "discardFolded" = true;
                    "discardFoldedDelay" = 30;
                    "discardFoldedDelayUnit" = "min";
                    "hideEmptyPanels" = false;
                    "hideFoldedTabs" = true;
                    # hmmm
                    # "syncSaveCtxMenu" = true;
                    # "syncSaveKeybindings" = true;
                    # "syncSaveSettings" = true;
                    # "syncSaveStyles" = true;
                    "tabsPanelSwitchActMove" = true;
                    "treeRmOutdent" = "first_child";
                  };
                  "keybindings" = {
                    "_execute_sidebar_action" = "MacCtrl+Ctrl+E";
                    "next_panel" = "Alt+Period";
                    "prev_panel" = "Alt+Comma";
                  };
                };
              };

              "${addons.tridactyl.addonId}" = {
                force = true;
                settings.userconfig = {
                  configversion = "2.0";
                  tabsort = "default";
                  nmaps = {
                    J = "tabprev";
                    K = "tabnext";

                    "g1" = "tab 1";
                    "g2" = "tab 2";
                    "g3" = "tab 3";
                    "g4" = "tab 4";
                    "g5" = "tab 5";
                    "g6" = "tab 6";
                    "g7" = "tab 7";
                    "g8" = "tab 8";
                    "g9" = "tab 9";

                    "<C-e>" = "mode normal"; # no-op, to leave space for sidebery

                    "<C-o>" = "tab #"; # last selected tab
                    "<C-i>" = "tab #"; # back again
                  };

                  newtab = "about:blank";
                  searchurls = {
                    google = "https://www.google.com/search?udm=14&q=";
                    scholar = "https://scholar.google.com/scholar?q=";
                    bing = "https://www.bing.com/search?q=";
                    duckduckgo = "https://duckduckgo.com/?q=";
                    ddg = "https://duckduckgo.com/?q=";
                    youtube = "https://www.youtube.com/results?search_query=";
                  };
                };
              };
            };
          };
        in
        {
          focus = common // {
            id = 0;
          };

          leisure = common // {
            id = 1;
            extensions.packages = builtins.attrValues addons;
          };
        };
    };
  };
}
