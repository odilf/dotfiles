{ pkgs, ... }:
{
  home-manager.users."*" = { hmConfig, ... }: {
    launchd.agents.osx-scrobbler = {
      config = {
        ProgramArguments = [ "${pkgs.osx-scrobbler}/bin/osx-scrobbler" ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${hmConfig.home.homeDirectory}/Library/Logs/osx-scrobbler.log";
        StandardErrorPath = "${hmConfig.home.homeDirectory}/Library/Logs/osx-scrobbler.err";
      };
    };

    # This is the config I use. I'm not configuring them declaratively because
    # secrets are a pain.
    #
    # ```
    # refresh_interval = 5
    # scrobble_threshold = 50
    #
    # [cleanup]
    # enabled = true
    # patterns = [
    #     '\s*\[Explicit\]',
    #     '\s*\[Clean\]',
    #     '\s*\(Explicit\)',
    #     '\s*\(Clean\)',
    #     '\s*- Explicit',
    #     '\s*- Clean',
    # ]
    #
    # [app_filtering]
    # prompt_for_new_apps = true
    # scrobble_unknown = true
    # allowed_apps = ["org.mozilla.firefox"]
    # ignored_apps = []
    #
    # [lastfm]
    # enabled = true
    # api_key = ""
    # api_secret = ""
    # session_key = "" # filled by `osx-scrobbler --auth-lastfm`
    #
    # [[listenbrainz]]
    # enabled = true
    # name = "Main"
    # api_url = "https://api.listenbrainz.org"
    # token = ""
    # ```
  };
}
