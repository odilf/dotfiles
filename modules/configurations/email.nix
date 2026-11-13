{ ... }: {
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        enable = config.programs.aerc.enable;
        inherit (pkgs.stdenv.hostPlatform) isLinux;
      in
      {
        age.secrets = lib.mkIf enable {
          radicale.file = ../../secrets/radicale.age;
          gmail.file = ../../secrets/gmail.age;
        };

        accounts.email = lib.mkIf enable {
          maildirBasePath = "bunker/data/mail";
          accounts.gmail = {
            primary = true;
            flavor = "gmail.com";
            address = "me@odilf.com";
            userName = "odysseas.maheras@gmail.com";
            realName = "Ody M";
            passwordCommand = "${pkgs.writeShellScript "gmail-pass" ''
              ${pkgs.coreutils}/bin/cat "${config.age.secrets.gmail.path}"
            ''}";

            notmuch.enable = true;

            mbsync = {
              enable = true;
              create = "maildir";
              patterns = [
                "INBOX"
                "[Gmail]/*"
              ];
            };

            msmtp.enable = true;

            aerc = {
              enable = true;
              extraAccounts = {
                default = "INBOX";
                outgoing = "msmtp -a Personal";
                copy-to = "";
                check-mail = "2m";
                check-mail-cmd = "notmuch new";
                multi-file-strategy = "act-dir";
              };
            };

            imapnotify = {
              enable = true;
              boxes = [ "INBOX" ];
              onNotify = "${pkgs.isync}/bin/mbsync gmail";
              onNotifyPost =
                if pkgs.stdenv.hostPlatform.isDarwin then
                  ''/usr/bin/osascript -e 'display notification "New mail" with title "Mail"' ''
                else
                  "${pkgs.libnotify}/bin/notify-send 'New mail'";
            };
          };
        };

        programs = {
          mbsync.enable = enable;
          msmtp.enable = enable;
          notmuch.enable = enable;
          aerc = {
            extraConfig = {
              general.unsafe-accounts-conf = true;
              ui.sort = "-r date";
              filters = {
                "text/plain" = "colorize";
                "text/calendar" = "calendar";
                "text/html" = "html | colorize";
              };
              viewer.alternatives = "text/plain,text/html";
              compose.address-book-cmd = lib.mkIf config.programs.khard.enable "${pkgs.khard}/bin/khard email --remove-first-line --parsable '%s'";
            };
            extraBinds =
              # Ugh... not doing this deletes all default binds...
              lib.replaceStrings
                [
                  "q = :prompt 'Quit?' quit<Enter>"
                  ":archive flat<Enter>"
                ]
                [
                  "q = :quit<Enter>"
                  ":delete<Enter>"
                ]
                (builtins.readFile "${pkgs.aerc}/share/aerc/binds.conf");
          };
        };

        # TODO: Do something on macos
        services.mbsync = lib.mkIf isLinux {
          enable = enable;
          frequency = "*:0/15";
        };

        services.imapnotify.enable = enable;
      }
    )
  ];
}
