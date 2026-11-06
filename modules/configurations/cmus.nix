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

  cmus-discord-script = pkgs.writeText "cmus-discord.py" ''
    import subprocess
    import sys
    import time

    from pypresence import Presence

    CLIENT_ID = "744268701150478359"

    rpc = Presence(CLIENT_ID)
    rpc.connect()
    while True:
        try:
            output = subprocess.check_output([ "cmus-remote", "-Q" ]).decode()
        except subprocess.CalledProcessError:
            rpc.clear()
            sys.exit(0)
        artist = "Unknown"
        title = "Not listening to anything"
        for line in output.splitlines():
            if line.startswith("tag artist "):
                artist = line.removeprefix("tag artist ")
            elif line.startswith("tag title "):
                title = line.removeprefix("tag title ")
        rpc.update(state=f"Listening to {artist}", details=title)
        time.sleep(5)
  '';

  cmus-discord = pkgs.writeShellScriptBin "cmus-discord" ''
    exec ${pkgs.python3.withPackages (ps: [ ps.pypresence ])}/bin/python3 \
      ${cmus-discord-script} "$@"
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
  home-manager.sharedModules = [
    (
      { config, lib, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) isDarwin;
        cmusPath = "${config.programs.cmus.package}/bin";
      in
      {
        home.packages = lib.mkIf config.programs.cmus.enable [
          cmus-status-scrobbler
          cmus-discord
        ];
        programs.cmus = {
          extraConfig = ''
            set status_display_program=${cmus-status-scrobbler}/bin/cmus-status-scrobbler
            set lib_sort=-filemtime
            fset jazz=genre="Jazz"
          '';
        };

        launchd.agents.cmus-discord = lib.mkIf (isDarwin && config.programs.cmus.enable) {
          enable = true;
          config = {
            ProgramArguments = [ "${cmus-discord}/bin/cmus-discord" ];
            RunAtLoad = true;
            KeepAlive = true;
            EnvironmentVariables.PATH = lib.concatStringsSep ":" [
              cmusPath
              "/run/current-system/sw/bin"
              "/usr/local/bin"
              "/usr/bin"
              "/bin"
              "/usr/sbin"
              "/sbin"
            ];
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/cmus-discord.log";
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/cmus-discord.err";
          };
        };

        systemd.user.services.cmus-discord = lib.mkIf (!isDarwin && config.programs.cmus.enable) {
          Unit = {
            Description = "Discord Rich Presence for cmus";
            After = [ "network-online.target" ];
          };
          Install.WantedBy = [ "default.target" ];
          Service = {
            Environment = [
              "PATH=${cmusPath}:/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            ];
            ExecStart = "${cmus-discord}/bin/cmus-discord";
            Restart = "always";
            RestartSec = "15";
          };
        };

        home.activation.cmusScrobblerConfig = lib.mkIf config.programs.cmus.enable (
          config.lib.dag.entryAfter [ "writeBoundary" ] ''
            CONFIG_FILE="${config.xdg.configHome}/cmus/cmus_status_scrobbler.ini"
            if [ ! -f "$CONFIG_FILE" ]; then
              $DRY_RUN_CMD mkdir -p "${config.xdg.configHome}/cmus"
              $DRY_RUN_CMD cp ${initial-config} "$CONFIG_FILE"
              $DRY_RUN_CMD chmod 644 "$CONFIG_FILE"
              echo "Created cmus scrobbler config template at $CONFIG_FILE"
            fi
          ''
        );
      }
    )
  ];
}
