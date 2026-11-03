{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.custom.headphone-keepalive;

  # Streams a continuous ultrasonic tone to the headset base so its USB audio
  # stream never closes and its silence-based auto-standby never triggers.
  # The device index is re-resolved on every reconnect because CoreAudio
  # re-enumerates USB devices on plug/unplug.
  keepaliveScript = pkgs.writeShellScript "headphone-keepalive" ''
    FFMPEG="${pkgs.ffmpeg}/bin/ffmpeg"
    DEVICE="${cfg.device}"
    FREQUENCY="${toString cfg.frequency}"
    VOLUME="${toString cfg.volume}"

    list_devices() {
      "$FFMPEG" -hide_banner -f lavfi -i anullsrc=r=48000:cl=stereo -t 0.05 \
        -f audiotoolbox -list_devices true -y /dev/null 2>&1 |
        sed -n 's/.*\[\([0-9][0-9]*\)\][[:space:]]*\([^,]*\),.*/\1 \2/p'
    }

    resolve_index() {
      local i name
      while read -r i name; do
        [ "$name" = "$DEVICE" ] || continue
        # Input-only entries reject the output stream; the first index that
        # accepts it is the base's output device.
        if "$FFMPEG" -hide_banner -loglevel error -nostdin \
          -f lavfi -i anullsrc=r=48000:cl=stereo -t 0.1 \
          -f audiotoolbox -audio_device_index "$i" -y /dev/null 2>/dev/null; then
          echo "$i"
          return 0
        fi
      done < <(list_devices)
      return 1
    }

    while true; do
      if ! idx=$(resolve_index); then
        echo "headphone-keepalive: device ''${DEVICE} not found, retrying in 10s" >&2
        sleep 10
        continue
      fi
      echo "headphone-keepalive: streaming ''${FREQUENCY}Hz tone at volume ''${VOLUME} to ''${DEVICE} (index $idx)" >&2
      "$FFMPEG" -hide_banner -loglevel error -nostdin \
        -f lavfi -i "sine=frequency=''${FREQUENCY}:sample_rate=48000,volume=''${VOLUME}" \
        -f audiotoolbox -audio_device_index "$idx" -y /dev/null
      echo "headphone-keepalive: stream to ''${DEVICE} ended, retrying in 5s" >&2
      sleep 5
    done
  '';
in
{
  options.custom.headphone-keepalive = lib.mkOption {
    description = "Keep a 2.4GHz headset base awake by streaming an inaudible tone to it.";
    default = { };
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "stream an inaudible keepalive tone to the headset base";
        device = lib.mkOption {
          type = lib.types.str;
          default = "USB Audio CODEC";
          description = "CoreAudio name of the headset base's output device.";
        };
        frequency = lib.mkOption {
          type = lib.types.int;
          default = 19000;
          description = "Keepalive tone frequency in Hz. 19kHz is above the hearing range of virtually all adults.";
        };
        volume = lib.mkOption {
          type = lib.types.float;
          default = 0.01;
          description = "Keepalive tone amplitude (0-1). Low enough to be imperceptible even if audible.";
        };
      };
    };
  };

  config = {
    custom.headphone-keepalive.enable = true;

    home-manager.sharedModules = lib.mkIf cfg.enable [
      (
        { config, ... }:
        {
          launchd.agents.headphone-keepalive = {
            enable = true;
            config = {
              ProgramArguments = [ "${keepaliveScript}" ];
              RunAtLoad = true;
              KeepAlive = true;
              # launchd's default PATH is minimal; add the usual system paths
              # so the script's external tools resolve.
              EnvironmentVariables.PATH = lib.concatStringsSep ":" [
                "/run/current-system/sw/bin"
                "/usr/local/bin"
                "/usr/bin"
                "/bin"
                "/usr/sbin"
                "/sbin"
              ];
              StandardOutPath = "${config.home.homeDirectory}/Library/Logs/headphone-keepalive.log";
              StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/headphone-keepalive.err";
            };
          };
        }
      )
    ];
  };
}
