{ ... }:
{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        ...
      }:
      let
        enable-cal = config.programs.khal.enable;
        enable-contacts = config.programs.khard.enable;
        enable-email = config.programs.thunderbird.enable;
        enable = enable-cal || enable-contacts;

        remote = type: {
          inherit type;
          url = "https://radicale.odilf.com/";
          userName = "odilf";
          passwordCommand = [
            "cat"
            config.age.secrets.radicale.path
          ];
        };
      in
      {
        age.secrets = lib.mkIf enable {
          radicale.file = ../../secrets/radicale.age;
          gmail.file = ../../secrets/gmail.age;
        };

        # TODO: Switch to `pimsync`
        programs.vdirsyncer.enable = enable;
        services.vdirsyncer.enable = enable;

        accounts.calendar = lib.mkIf enable-cal {
          basePath = ".accounts/calendar";
          accounts.main = {
            primary = true;
            khal = {
              enable = true;
              addresses = [ "odysseas.maheras@gmail.com" ];
              type = "discover";
            };
            thunderbird.enable = true;
            vdirsyncer = {
              enable = true;
              collections = [
                "from a"
                "from b"
              ];
            };

            remote = remote "caldav";
            local = {
              type = "filesystem";
              fileExt = ".ics";
            };
          };
        };

        accounts.contact = lib.mkIf enable-contacts {
          basePath = ".accounts/contacts";
          accounts.main = {
            khal.enable = true;
            khard = {
              enable = true;
              type = "discover";
            };
            thunderbird.enable = true;
            vdirsyncer = {
              enable = true;
              collections = [
                "from a"
                "from b"
              ];
            };

            remote = remote "carddav";
            local = {
              type = "filesystem";
              fileExt = ".vcf";
            };
          };
        };

        accounts.email = lib.mkIf enable-email {
          maildirBasePath = ".accounts/mail";
          accounts.gmail = {
            primary = true;
            flavor = "gmail.com";
            address = "odysseas.maheras@gmail.com";
            aliases = [ "me@odilf.com" ];
            realName = "Ody";
            passwordCommand = [
              "cat"
              config.age.secrets.gmail.path
            ];
            # Himalaya does not negotiate SASL mechanisms, so it has to be
            # pinned explicitly. Gmail accepts PLAIN over TLS.
            imap.authentication = "plain";
            smtp.authentication = "plain";
            himalaya.enable = true;
            thunderbird.enable = true;
          };
        };

        programs.thunderbird = lib.mkIf enable-email {
          profiles.default.isDefault = true;
        };
      }
    )
  ];
}
