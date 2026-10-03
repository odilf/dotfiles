{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  addons = import ../derivations/firefox-addons.nix { inherit pkgs; };
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
          id = 0; # default profile — plain `librewolf` lands here
          settings."extensions.autoDisableScopes" = 0;
          extensions.packages = [
            addons.ublock-origin
            addons.leechblock-ng
            addons.bitwarden
          ];
        };

        leisure = {
          id = 1; # opt-in via `librewolf -P leisure`
          settings."extensions.autoDisableScopes" = 0;
          extensions.packages = builtins.attrValues addons;
        };
      };
    };
  };
}
