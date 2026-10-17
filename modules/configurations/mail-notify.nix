{ ... }:
{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (pkgs.stdenv.hostPlatform) isDarwin;

        enabled = config.accounts.email.accounts ? gmail;
        account = config.accounts.email.accounts.gmail;

        notify =
          mailbox:
          if isDarwin then
            ''exec ${pkgs.terminal-notifier}/bin/terminal-notifier -title "New mail" -subtitle "${mailbox}" -message "New mail in ${mailbox}" -sound default -group new-mail''
          else
            ''exec ${pkgs.libnotify}/bin/notify-send "New mail" "New mail in ${mailbox}"'';

        # goimapnotify also runs onNewMail for a synthetic sync event on every
        # (re)start; only notify on real arrivals.
        onNewMail = ''[ "{{.Reason}}" = "New Email" ] && ${notify "{{.Mailbox}}"} || true'';

        configFile = pkgs.writeText "goimapnotify.json" (
          builtins.toJSON {
            configurations = [
              {
                host = "imap.gmail.com";
                port = 993;
                tls = true;
                tlsOptions = {
                  rejectUnauthorized = true;
                  starttls = false;
                };
                username = account.address;
                passwordCMD = "${pkgs.coreutils}/bin/cat \"${config.age.secrets.gmail.path}\"";
                boxes = [
                  {
                    mailbox = "INBOX";
                    inherit onNewMail;
                  }
                ];
              }
            ];
          }
        );
      in
      lib.mkIf enabled {
        launchd.agents.mail-notify = lib.mkIf isDarwin {
          enable = true;
          config = {
            ProgramArguments = [
              "${pkgs.goimapnotify}/bin/goimapnotify"
              "-conf"
              "${configFile}"
            ];
            RunAtLoad = true;
            KeepAlive = true;
            # launchd's default PATH is minimal; add the Nix system profile
            # so `sh -c` hooks can find their tools.
            EnvironmentVariables.PATH = lib.concatStringsSep ":" [
              "/run/current-system/sw/bin"
              "/usr/local/bin"
              "/usr/bin"
              "/bin"
              "/usr/sbin"
              "/sbin"
            ];
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/mail-notify.log";
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/mail-notify.err";
          };
        };

        systemd.user.services.mail-notify = lib.mkIf (!isDarwin) {
          Unit = {
            Description = "Notify on new mail via IMAP IDLE";
            Wants = [ "network-online.target" ];
            After = [ "network-online.target" ];
          };
          Install.WantedBy = [ "default.target" ];
          Service = {
            Environment = [
              "PATH=/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            ];
            ExecStart = "${pkgs.goimapnotify}/bin/goimapnotify -conf ${configFile}";
            Restart = "on-failure";
            RestartSec = "10";
          };
        };
      }
    )
  ];
}
