{ pkgs, ... }: {
  home-manager.users."*".programs.yazi = {
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
