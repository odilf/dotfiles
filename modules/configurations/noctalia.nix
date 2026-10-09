{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  # TODO: Don't hardcode niri
  enable = isLinux && config.programs.niri.enable;

  homeConfig =
    { osConfig, lib, ... }:
    {
      imports = [
        osConfig.passthru.noctalia
      ];

      programs.noctalia.settings = {
        bar = {
          density = "compact";
          position = "top";
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
              }
              {
                displayMode = "graphic";
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
                labelMode = "name";
                colorizeIcons = false;
                iconScale = 0.7;
                unfocusedIconsOpacity = 0.4;
              }
            ];
            right = [
              {
                id = "plugin:network-indicator";
              }
              {
                id = "plugin:mpd";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "Brightness";
                displayMode = "alwaysShow";
              }
              {
                id = "SystemMonitor";
                compactMode = true;
                showCpuCores = false;
                showCpuFreq = false;
                showCpuTemp = true;
                showCpuUsage = true;
                showMemoryUsage = true;
                showSwapUsage = true;
              }
            ];
          };
        };

        controlCenter = {
          shortcuts = {
            left = lib.map (id: { inherit id; }) [
              "Network"
              "Bluetooth"
              "WallpaperSelector"
              "NoctaliaPerformance"
            ];
            right = lib.map (id: { inherit id; }) [
              "Notifications"
              "PowerProfile"
              "KeepAwake"
              "NightLight"
              "DarkMode"
            ];
          };
        };

        brightness = {
          brightnessStep = 2;
        };
        colorSchemes = {
          darkMode = true;
          schedulingMode = "off";
          useWallpaperColors = true;
          generationMethod = "rainbow";
        };
        dock = {
          animationSpeed = 0.1;
          deadOpacity = 0.6;
        };
        general = {
          avatarImage = ../../logo.svg;
          radiusRatio = 0.2;
          animationSpeed = 1.5;
          enableShadows = false;
        };
        location = {
          monthBeforeDay = true;
          name = "Madrid, Spain";
        };
        nightLight = {
          autoSchedule = true;
        };
        notifications = {
          backgroundOpacity = 0.9;
          density = "compact";
        };

        wallpaper = {
          automationEnabled = true;
          enabled = true;
          directory = "/var/lib/immich-pics/wallpapers_desktop";
          overviewEnabled = false;
          randomIntervalSec = 600;
        };

        templates = {
          activeTemplates =
            lib.map
              (id: {
                enabled = true;
                inherit id;
              })
              [
                "btop"
                "gtk"
                "qt"
                "niri"
                "discord"
              ];
          enableUserTheming = false;
        };
      };
    };
in
{
  networking.networkmanager.enable = lib.mkIf enable (lib.mkDefault true);
  hardware.bluetooth.enable = lib.mkIf enable (lib.mkDefault true);
  # services.tuned.enable = lib.mkIf enable (lib.mkDefault true);
  services.upower.enable = lib.mkIf enable (lib.mkDefault true);

  # Download wallpepers from immich
  age.secrets.immich-wallpapers-token.file = ../../secrets/immich-wallpapers-token.age;
  services.immich-album-downloader = {
    enable = enable;
    localUrl = "http://192.168.0.40:2283";
    remoteUrl = "https://photos.odilf.com";
    albumId = "665dd9ea-a89e-4094-9fdf-d5998580c98b";
    sessionTokenFile = "${config.age.secrets.immich-wallpapers-token.path}";
    downloadDir = "/var/lib/immich-wallpapers";
    schedule = "*-*-* 03:00:00"; # 3 AM daily
  };

  home-manager.sharedModules = lib.mkIf enable [ homeConfig ];
}
