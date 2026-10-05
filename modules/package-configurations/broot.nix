{ ... }:
{
  home-manager.sharedModules = [
    {
      programs.broot = {
        # NOTE: Author says better not to enable, but just in case...
        # settings.modal = true;
      };
    }
  ];
}
