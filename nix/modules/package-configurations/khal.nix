{ ... }:
{
  home-manager.users."*" =
    { hmConfig, ... }:
    let
      local = {
        type = "filesystem";
        fileExt = ".ics";
      };

      remote = {
        type = "caldav";
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

      programs.khal.enable = true;
      vdirsyncer.enable = true;
      programs.vdirsyncer.enable = true;
      services.vdirsyncer = {
        enable = true;
        frequency = "hourly";
      };

      accounts.calendar = {
        basePath = ".calendar";
        accounts = {
          personal = {
            primary = true;
            khal = {
              enable = true;
              color = "dark blue";
              priority = 10;
              readOnly = false;
              type = "calendar";
            };

            vdirsyncer = {
              enable = true;
              collections = [
                "personal"
              ];
            };

            inherit local remote;
          };

          professional = {
            khal = {
              enable = true;
              color = "dark red";
              priority = 15;
              readOnly = false;
              type = "discover";
            };

            vdirsyncer = {
              enable = true;
              collections = [
                "uc3m"
                "uc3m-schedule"
                "exams"
              ];
            };

            inherit local remote;
          };
        };
      };
    };
}
