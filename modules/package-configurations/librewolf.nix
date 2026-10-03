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
        # "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
        "findbar.highlightAll" = true;
        "accessibility.typeaheadfind.flashBar" = 0;

        # New tab
        "browser.newtabpage.enabled" = false;

        # Downloads, updates, media
        "browser.download.useDownloadDir" = true;
        "extensions.update.enabled" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
      };

      profiles = {
        focus = {
          id = 0;
          settings."extensions.autoDisableScopes" = 0;
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
        };

        leisure = {
          id = 1;
          settings."extensions.autoDisableScopes" = 0;
          extensions.packages = builtins.attrValues addons;
        };
      };
    };
  };
}
