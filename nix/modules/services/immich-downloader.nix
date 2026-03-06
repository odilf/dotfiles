# Immich Album Downloader NixOS Module
# This module creates a systemd service and timer to run the Immich album downloader daily
#
# Usage:
# 1. Place immich-album-downloader.sh in the same directory as this module
# 2. Add this file to your NixOS configuration (e.g., /etc/nixos/immich-downloader.nix)
# 3. Import it in your configuration.nix:
#    imports = [ ./immich-downloader.nix ];
# 4. Configure the service (see configuration example at bottom of file)

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.immich-album-downloader;

  # Read the external script and substitute package paths
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
    enable = mkEnableOption "Immich album downloader service";

    localUrl = mkOption {
      type = types.str;
      example = "http://192.168.1.100:2283";
      description = "Local Immich instance URL (tried first)";
    };

    remoteUrl = mkOption {
      type = types.str;
      example = "https://immich.example.com";
      description = "Remote Immich instance URL (fallback)";
    };

    albumId = mkOption {
      type = types.str;
      example = "abc123-def456-ghi789";
      description = "Immich album ID to download";
    };

    sessionTokenFile = mkOption {
      type = types.path;
      example = "/run/secrets/immich-token";
      description = ''
        Path to file containing the Immich session token.
        This should be a secure file readable only by root.
        The file should contain only the token string.
      '';
    };

    downloadDir = mkOption {
      type = types.path;
      default = "/var/lib/immich-downloads";
      description = "Directory where images will be downloaded";
    };

    schedule = mkOption {
      type = types.str;
      default = "daily";
      example = "*-*-* 02:00:00";
      description = ''
        When to run the download (systemd timer format).
        Default: "daily" (runs once per day at midnight)
        For more control, use systemd calendar format like "*-*-* 02:00:00" (2 AM daily)
      '';
    };

    user = mkOption {
      type = types.str;
      default = "immich-downloader";
      description = "User to run the service as";
    };

    group = mkOption {
      type = types.str;
      default = "immich-downloader";
      description = "Group to run the service as";
    };
  };

  config = mkIf cfg.enable {

    # Create system user and group
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "Immich album downloader service user";
      home = cfg.downloadDir;
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    # Systemd service
    systemd.services.immich-album-downloader = {
      description = "Download Immich album";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      requires = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;

        # Environment variables
        Environment = [
          "IMMICH_LOCAL_URL=${cfg.localUrl}"
          "IMMICH_REMOTE_URL=${cfg.remoteUrl}"
          "IMMICH_ALBUM_ID=${cfg.albumId}"
          "DOWNLOAD_DIR=${cfg.downloadDir}"
        ];

        # Load session token from file
        EnvironmentFile = cfg.sessionTokenFile;

        # Security hardening
        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.downloadDir ];

        # Set permissions on downloaded files to be world-readable
        UMask = "0022";

        # Run the script
        ExecStart = "${downloadScript}/bin/immich-album-downloader";

        # Logging
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
