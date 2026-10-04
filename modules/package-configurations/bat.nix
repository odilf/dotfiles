{ lib, ... }:
{
  home-manager.users."*" =
    { hmConfig, ... }:
    {
      programs.bat.config = {
        plain = true;
      };

      home.sessionVariables.PAGER = lib.mkIf hmConfig.programs.bat.enable "bat";
    };
}
