{ ... }:
{
  home-manager.sharedModules = [
    {
      programs.mpv = {
        config = {
          keep-open = true;
        };
      };
    }
  ];
}
