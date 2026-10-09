{ ... }:
{
  home-manager.sharedModules = [
    (
      { config, lib, ... }:
      {
        programs.bat.config = {
          plain = true;
        };

        home.sessionVariables.PAGER = lib.mkIf config.programs.bat.enable "bat";
      }
    )
  ];
}
