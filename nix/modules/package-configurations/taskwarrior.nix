{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  pkg = pkgs.taskwarrior3;
in
{

  home-manager.users."*" =
    { hmConfig, ... }:
    {
      age.secrets.taskwarrior.file = ../../secrets/taskwarrior.age;

      programs.taskwarrior = {
        package = pkg;
        config = {
          confirmation = false;
        };
        extraConfig = "include ${hmConfig.age.secrets.taskwarrior.path}";
      };

      # Sync every change every 5 seconds
      home.file."${hmConfig.xdg.dataHome}/task/hooks/on-modify-sync" = {
        executable = true;

        text = ''
          FLAGFILE="/tmp/taskwarrior-needs-sync"
          PIDFILE="/tmp/taskwarrior-sync.pid"

          # Echo tasks
          read original_task
          read added_task
          echo "$added_task"

          # Mark that we need a sync
          touch "$FLAGFILE"

          # Exit if sync process already running
          if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
            exit 0
          fi

          # Start background sync process
          nohup ${lib.getExe pkgs.bash} -c '
            echo $$ > "'"$PIDFILE"'"
            sleep 5
            if [ -f "'"$FLAGFILE"'" ]; then
              rm "'"$FLAGFILE"'"
              '"${lib.getExe pkg}"' rc.hooks=off sync
            fi
            rm -f "'"$PIDFILE"'"
          ' > /dev/null 2>&1 </dev/null &

          exit 0
        '';
      };

      # Sync changes from other devices every 5 minutes
      home.file."${hmConfig.xdg.dataHome}/task/hooks/on-launch-sync" = {
        executable = true;
        text = ''
          FLAGFILE="/tmp/taskwarrior-needs-sync"
          LAST_SYNC="/tmp/taskwarrior-last-sync"
          SYNC_INTERVAL=300  # 5 minutes

          # Only sync if enough time has passed
          time_passed=$(($(date +%s) - $(date -r "$LAST_SYNC" +%s 2>/dev/null || echo 0)))
          if [ $time_passed -lt $SYNC_INTERVAL ]; then
            exit 0
          fi

          ${lib.getExe pkg} rc.hooks=off sync > /dev/null 2>&1
          touch "$LAST_SYNC"
          exit 0
        '';
      };

      services.taskwarrior-sync = {
        enable = hmConfig.programs.taskwarrior.enable && isLinux;
        package = pkg;
        frequency = "*:0/5";
      };
    };
}
