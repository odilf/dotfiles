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
        enable-calendars = config.programs.khal.enable;
        enable-contacts = config.programs.khard.enable;
        enable = enable-calendars || enable-contacts;

        remote = type: {
          inherit type;
          url = "https://radicale.odilf.com";
          userName = "odilf";
          passwordCommand = [
            "${pkgs.writeShellScript "radicale-pass" ''
              ${pkgs.coreutils}/bin/cat "${config.age.secrets.radicale.path}"
            ''}"
          ];
        };
      in
      {
        age.secrets = lib.mkIf enable {
          radicale.file = ../../secrets/radicale.age;
        };

        programs.pimsync.enable = enable;
        services.pimsync.enable = enable;

        accounts.contact = lib.mkIf enable-contacts {
          basePath = "bunker/data/contacts";
          accounts.main = {
            khard = {
              enable = true;
              type = "discover"; # to find in subdirectories
            };
            pimsync = {
              enable = true;
              extraPairDirectives = [
                {
                  name = "collections";
                  params = [
                    "all"
                  ];
                }
              ];
            };
            remote = remote "carddav";
            local = {
              type = "filesystem";
              fileExt = ".vcf";
            };
          };
        };

        accounts.calendar = lib.mkIf enable-calendars {
          basePath = "bunker/data/calendars";
          accounts.main = {
            khal = {
              enable = true;
              type = "discover";
            };
            pimsync = {
              enable = true;
              extraPairDirectives = [
                {
                  name = "collections";
                  params = [
                    "all"
                  ];
                }
              ];
            };
            remote = remote "caldav";
            local = {
              type = "filesystem";
              fileExt = ".vcf";
            };
          };
        };
      }
    )
  ];
}
