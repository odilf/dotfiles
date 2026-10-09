{ ... }:
{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        programs.yazi = {
          extraPackages = [
            pkgs.exiftool
            pkgs.mediainfo
            pkgs.glow
            # pkgs.ouch
            # pkgs.ouch-rar
          ];

          shellWrapperName = "y";
        };
      }
    )
  ];
}
