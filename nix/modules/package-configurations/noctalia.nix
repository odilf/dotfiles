{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  networking.networkmanager.enable = lib.mkDefault true;
  hardware.bluetooth.enable = lib.mkDefault true;
  # services.tuned.enable = lib.mkDefault true;
  services.upower.enable = lib.mkDefault true;

  home-manager.users."*" = lib.mkIf isLinux {
    imports = [
      config.passthru.noctalia
    ];

    programs.noctalia-shell.settings = {
      bar = {
        density = "mini";
        position = "right";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
            {
              displayMode = "alwaysShow";
              alwaysShowPercentage = true;
              id = "Battery";
              warningThreshold = 20;
              showNoctaliaPerformance = true;
              showPowerProfiles = true;
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
              colorizeIcons = true;
              iconScale = 0.7;
              unfocusedIconsOpacity = 0.3;
            }
          ];
          right = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Brightness";
            }
            {
              "id" = "plugin:catwalk";
            }
          ];
        };
      };

      brightness = {
        brightnessStep = 2;
      };
      colorSchemes = {
        predefinedScheme = "Eldritch";
        schedulingMode = "location";
        useWallpaperColors = true;
      };
      dock = {
        animationSpeeed = 2;
        deadOpacity = 0.6;
      };
      general = {
        avatarImage = ../../../logo.svg;
        radiusRatio = 0.2;
        animationSpeed = 1.5;
      };
      location = {
        monthBeforeDay = true;
        name = "Madrid, Spain";
      };
      nightLight = {
        autoSchedule = true;
      };

      wallpaper = {
        enabled = true;
        directory = ../../../wallpapers;
        overviewEnabled = false;
        randomEnabled = true;
        randomIntervalSec = 600;
      };
    };
  };
}
// {
  systemd =
    let
      # Configuration
      immichUrl = "https://photos.odilf.com";
      albumId = "https://photos.odilf.com/share/ta7p-JiU5xRpFzF90ggnwP-WTsS9YGBTVDPYgl0qAge02KVyziACs3InEzyzLaEcKfA";
      photosDir = "/var/lib/wallpapers-immich";

      # Sync script
      syncScript = pkgs.writeShellScript "sync-immich-album" ''
        set -e

        PHOTOS_DIR="${photosDir}"
        mkdir -p "$PHOTOS_DIR"

        # Fetch album metadata
        album_json=$(${pkgs.curl}/bin/curl -s "${immichUrl}/api/albums/${albumId}")

        # Extract asset IDs and download photos
        echo "$album_json" | ${pkgs.jq}/bin/jq -r '.assets[].id' | while read asset_id; do
          # Get original filename
          asset_info=$(${pkgs.curl}/bin/curl -s \
            "${immichUrl}/api/assets/$asset_id")
          
          filename=$(echo "$asset_info" | ${pkgs.jq}/bin/jq -r '.originalFileName')
          filepath="$PHOTOS_DIR/$filename"
          
          # Download if not already present
          if [ ! -f "$filepath" ]; then
            echo "Downloading $filename..."
            ${pkgs.curl}/bin/curl -s \
              "${immichUrl}/api/assets/$asset_id/original" \
              -o "$filepath"
          fi
        done

        echo "Sync complete. Photos in $PHOTOS_DIR"
      '';

    in
    {
      # Systemd service to sync photos
      services.immich-photo-sync = {
        description = "Sync photos from Immich album";

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${syncScript}";
          StateDirectory = "wallpapers-immich";
          DynamicUser = true;
        };
      };

      # Timer to run sync periodically (daily at 3am)
      timers.immich-photo-sync = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
      };

      # Photos will be available at: /var/lib/wallpapers-immich
      # Run manually with: systemctl start immich-photo-sync
    };
}
