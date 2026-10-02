{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  home-manager.users."*" = {
    programs.librewolf = {
      package = lib.mkIf isLinux pkgs.librewolf-bin;
      settings = {
        # Startup & UI
        "browser.aboutConfig.showWarning" = false;
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.tabs.warnOnClose" = true;
        "browser.startup.page" = 3;
        # "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "findbar.highlightAll" = true;
        "accessibility.typeaheadfind.flashBar" = 0;

        # New tab
        "browser.newtabpage.enabled" = false;

        # Search & urlbar
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.search.update" = false;

        # Forms & passwords
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # Downloads, updates, media
        "browser.download.useDownloadDir" = false;
        "extensions.update.enabled" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

        # Reader mode
        "reader.content_width" = 5;
        "reader.font_size" = 4;
        "reader.text_alignment" = "left";
      };
    };
  };
}
