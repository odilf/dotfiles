{ pkgs, lib, ... }:
{
  home-manager.users."*" =
    { hmConfig, ... }:
    let
      enable-cal = hmConfig.programs.khal.enable;
      enable-contacts = hmConfig.programs.khard.enable;
      enable = enable-cal || enable-contacts;

      remote = type: {
        inherit type;
        url = "https://radicale.odilf.com/";
        userName = "odilf";
        passwordCommand = [
          "cat"
          hmConfig.age.secrets.radicale.path
        ];
      };
    in
    {
      age.secrets.radicale.file = ../../secrets/radicale.age;

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

      accounts.email = {
        maildirBasePath = ".accounts/mail";
        accounts.gmail = {
          primary = true;
          address = "odysseas.maheras@gmail.com";
          aliases = [
            "main"
            "personal"
            "odilf"
          ];
          userName = "Odilf";
          realName = "Ody";
          himalaya.enable = true;
          imapnotify = {
            enable = true;
            onNotify = "${pkgs.libnotify}/bin/notify-send 'New mail: %s' -t 2000";
          };
          # meli.enable = true;
          thunderbird.enable = true;
        };
      };
    };
}
