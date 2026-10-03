{
  stdenv,
  fetchurl,
}:
let
  buildFirefoxAddon =
    {
      pname,
      version,
      addonId,
      url,
      hash,
      description,
    }:
    stdenv.mkDerivation {
      inherit pname version;
      meta = {
        inherit description;
        homepage = "https://addons.mozilla.org/firefox/addon/${pname}/";
        mozPermissions = [ ];
      };
      src = fetchurl { inherit url hash; };
      preferLocalBuild = true;
      allowSubstitutes = true;
      passthru = {
        inherit addonId;
        updateScript = [
          ./firefox-addons-update.py
          addonId
        ];
      };
      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -m 644 "$src" "$dst/${addonId}.xpi"
      '';
    };
in
{
  betterttv = buildFirefoxAddon {
    pname = "betterttv";
    version = "7.7.25";
    addonId = "firefox@betterttv.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4903880/betterttv-7.7.25.xpi";
    hash = "sha256-uxo8r/aFwSWgx/MoXNeanqTMFEE8TPzxH6MlDRjC9tw=";
    description = "BetterTTV";
  };

  bitwarden = buildFirefoxAddon {
    pname = "bitwarden-password-manager";
    version = "2025.10.0";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4599707/bitwarden_password_manager-2025.10.0.xpi";
    hash = "sha256-MbiHQ/NgMvo8+3jgWC+3Mu8Ao8WRUYK6N/0IsEqsHTs=";
    description = "Bitwarden Password Manager";
  };

  clearurls = buildFirefoxAddon {
    pname = "clearurls";
    version = "1.27.3";
    addonId = "{74145f27-f039-47ce-a470-a662b129930a}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4432106/clearurls-1.27.3.xpi";
    hash = "sha256-VJJrbkJ01ZNaX8DapjIPHTcePS8aWHdGfKOrIqZcTyA=";
    description = "ClearURLs";
  };

  darkreader = buildFirefoxAddon {
    pname = "darkreader";
    version = "4.9.112";
    addonId = "addon@darkreader.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4598977/darkreader-4.9.112.xpi";
    hash = "sha256-3B/Ce15hZi8eHopgy/jhGndEOIjkBgP4jbfGueTstDc=";
    description = "Dark Reader";
  };

  indie-wiki-buddy = buildFirefoxAddon {
    pname = "indie-wiki-buddy";
    version = "3.14.6";
    addonId = "{cb31ec5d-c49a-4e5a-b240-16c767444f62}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4815321/indie_wiki_buddy-3.14.6.xpi";
    hash = "sha256-7V6b006yhaUSBcFJuWMmbkkMN0Ki/p7FAhGwNJK8YSs=";
    description = "Indie Wiki Buddy";
  };

  leechblock-ng = buildFirefoxAddon {
    pname = "leechblock-ng";
    version = "1.7.1";
    addonId = "leechblockng@proginosko.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4601510/leechblock_ng-1.7.1.xpi";
    hash = "sha256-4ktdktGyPtIyI6IoPineElkFMTAE6/WYASw36pKk6Bw=";
    description = "LeechBlock NG";
  };

  lichess2chess = buildFirefoxAddon {
    pname = "lichess2chess";
    version = "1.4";
    addonId = "{aa60beb9-2577-4eea-ae50-14a97ad9653d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4533408/lichess2chess-1.4.xpi";
    hash = "sha256-yoGcm3MPpyL9QVpns8xUsOTfqT+i0EjJnKUNPSwK8Pg=";
    description = "Lichess2Chess";
  };

  music-score-downloader = buildFirefoxAddon {
    pname = "music-score-downloader";
    version = "0.5.17";
    addonId = "{c88c53f2-6af9-4575-bea0-48e206743baf}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4687262/music_score_downloader-0.5.17.xpi";
    hash = "sha256-m8DS0+2SCcQMjs8JwJ4DeB/nJQxLMdlpynDbprLxddw=";
    description = "Music Score Downloader";
  };

  sidebery = buildFirefoxAddon {
    pname = "sidebery";
    version = "5.3.3";
    addonId = "{3c078156-979c-498b-8990-85f7987dd929}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4442132/sidebery-5.3.3.xpi";
    hash = "sha256-pPmoMF+Tt9a5XyeUPs0bPUInc/rluAK+rDr0o+OnR2s=";
    description = "Sidebery";
  };

  simple-translate = buildFirefoxAddon {
    pname = "simple-translate";
    version = "3.0.0";
    addonId = "simple-translate@sienori";
    url = "https://addons.mozilla.org/firefox/downloads/file/4286113/simple_translate-3.0.0.xpi";
    hash = "sha256-yeNtHY4yoiPaNnvcgxM/JDYQPrXxZGDHzOIJY3bni2g=";
    description = "Simple Translate";
  };

  styl-us = buildFirefoxAddon {
    pname = "styl-us";
    version = "2.3.16";
    addonId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4554444/styl_us-2.3.16.xpi";
    hash = "sha256-LNo0RfHl5aqVuLgUzDlQeRhSFuEOxC0ggRsDUPTDeKg=";
    description = "Stylus";
  };

  tab-volume-control = buildFirefoxAddon {
    pname = "tab-volume-control";
    version = "2.4.0";
    addonId = "tab-volume-control@sebastianengvall.github.io";
    url = "https://addons.mozilla.org/firefox/downloads/file/4880384/tab_volume_control-2.4.0.xpi";
    hash = "sha256-VPsel1RmyoAj84m+9P/vHVZx3jgULsJkyImudoujMao=";
    description = "Tab Volume Control";
  };

  tridactyl = buildFirefoxAddon {
    pname = "tridactyl-vim";
    version = "1.25.1";
    addonId = "tridactyl.vim@cmcaine.co.uk";
    url = "https://addons.mozilla.org/firefox/downloads/file/5014416/tridactyl_vim-1.25.1.xpi";
    hash = "sha256-ciwsbfwD2A5I+utMMRPTMCA5QEg+P8/GwdQQ4cxYVj4=";
    description = "Vim, but in your browser.";
  };

  ublock-origin = buildFirefoxAddon {
    pname = "ublock-origin";
    version = "1.67.0";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4598854/ublock_origin-1.67.0.xpi";
    hash = "sha256-uDxuxJ+Beo0F0oi1PbxwBczsz4LpSQ2Gg7MSCqs8Ezo=";
    description = "uBlock Origin";
  };

  web-scrobbler = buildFirefoxAddon {
    pname = "web-scrobbler";
    version = "3.22.0";
    addonId = "{799c0914-748b-41df-a25c-22d008f9e83f}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4832008/web_scrobbler-3.22.0.xpi";
    hash = "sha256-88a4hZ73PtJ3KXlClxlkK7N4FE2+iBkCqegaAEdXFKo=";
    description = "Web Scrobbler";
  };
}
