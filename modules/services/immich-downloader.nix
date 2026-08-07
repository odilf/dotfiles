{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.services.immich-album-downloader;

  downloadScript = pkgs.writeScriptBin "immich-album-downloader" ''
    #!${pkgs.bash}/bin/bash
    ${builtins.replaceStrings
      [ "curl" "jq" "grep" ]
      [ "${pkgs.curl}/bin/curl" "${pkgs.jq}/bin/jq" "${pkgs.gnugrep}/bin/grep" ]
      (builtins.readFile ./immich-album-downloader.sh)
    }
  '';
in
{
  options.services.immich-album-downloader = {
    enable = lib.mkEnableOption "Immich album downloader service";

    localUrl = lib.mkOption {
      type = lib.types.str;
      example = "http://192.168.1.100:2283";
      description = "Local Immich instance URL";
    };

    remoteUrl = lib.mkOption {
      type = lib.types.str;
      example = "https://immich.example.com";
      description = "Remote Immich instance URL";
    };

    albumId = lib.mkOption {
      type = lib.types.str;
      example = "abc123-def456-ghi789";
      description = "Immich album ID to download";
    };

    sessionTokenFile = lib.mkOption {
      type = lib.types.path;
      example = "/run/secrets/immich-token";
    };

    downloadDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/immich-downloads";
      description = "Directory where images will be downloaded";
    };

    schedule = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      example = "*-*-* 02:00:00";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "immich-downloader";
      description = "User to run the service as";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "immich-downloader";
      description = "Group to run the service as";
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "Immich album downloader service user";
      home = cfg.downloadDir;
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    systemd.services.immich-album-downloader = {
      description = "Download Immich album";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      requires = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;

        ExecStart = "${downloadScript}/bin/immich-album-downloader";

        # Ensure correct permissions before running
        ExecStartPre = [
          "${pkgs.coreutils}/bin/chmod 755 ${cfg.downloadDir}"
          "${pkgs.coreutils}/bin/chown ${cfg.user}:${cfg.group} ${cfg.downloadDir}"
        ];

        Environment = [
          "IMMICH_LOCAL_URL=${cfg.localUrl}"
          "IMMICH_REMOTE_URL=${cfg.remoteUrl}"
          "IMMICH_ALBUM_ID=${cfg.albumId}"
          "DOWNLOAD_DIR=${cfg.downloadDir}"
        ];
        EnvironmentFile = cfg.sessionTokenFile;

        # Security hardening
        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.downloadDir ];

        # Set permissions on downloaded files to be world-readable
        UMask = "0022";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    # Set directory permissions to be accessible to all users
    systemd.tmpfiles.rules = [
      "d ${cfg.downloadDir} 0755 ${cfg.user} ${cfg.group} -"
    ];

    # Systemd timer
    systemd.timers.immich-album-downloader = {
      enable = cfg.enable;
      description = "Timer for Immich album downloader";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = cfg.schedule;
        Persistent = true;
        RandomizedDelaySec = "5m";
      };
    };
  };
}
