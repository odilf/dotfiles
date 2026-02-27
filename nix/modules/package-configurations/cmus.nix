{ pkgs, ... }:

let
  cmus-status-scrobbler-src = pkgs.fetchFromGitHub {
    owner = "vjeranc";
    repo = "cmus-status-scrobbler";
    rev = "main";
    sha256 = "sha256-arhfBd2+YPg0yprtJrdNhe9IyF1aRDupvJhhiRMzPgY=";
  };

  cmus-status-scrobbler = pkgs.writeShellScriptBin "cmus-status-scrobbler" ''
    exec ${pkgs.python3.withPackages (ps: [ ps.requests ])}/bin/python3 \
      ${cmus-status-scrobbler-src}/cmus_status_scrobbler.py "$@"
  '';

  initial-config = pkgs.writeText "cmus_status_scrobbler.ini" ''
    [global]
    now_playing = yes
    api_key = 3f427fc05464646ddf068ca2b02fbb6c
    shared_secret = 9b57c32410ec5b068a4f39715a85ef79

    [lastfm]
    api_url = https://ws.audioscrobbler.com/2.0/
    auth_url = https://www.last.fm/api/auth/

    [listenbrainz]
    api_url = https://listenbrainz.org/2.0/
    auth_url = https://listenbrainz.org/api/auth/
    ; current workaround for listenbrainz (server fails on format=json)
    format_xml = yes
  '';
in
{
  home-manager.users."*" =
    { hmConfig, ... }:
    {
      home.packages = [ cmus-status-scrobbler ];
      programs.cmus = {
        extraConfig = ''
          set status_display_program=${cmus-status-scrobbler}/bin/cmus-status-scrobbler
        '';
      };

      home.activation.cmusScrobblerConfig = hmConfig.lib.dag.entryAfter [ "writeBoundary" ] ''
        CONFIG_FILE="${hmConfig.xdg.configHome}/cmus/cmus_status_scrobbler.ini"
        if [ ! -f "$CONFIG_FILE" ]; then
          $DRY_RUN_CMD mkdir -p "${hmConfig.xdg.configHome}/cmus"
          $DRY_RUN_CMD cp ${initial-config} "$CONFIG_FILE"
          $DRY_RUN_CMD chmod 644 "$CONFIG_FILE"
          echo "Created cmus scrobbler config template at $CONFIG_FILE"
        fi
      '';
    };
}
