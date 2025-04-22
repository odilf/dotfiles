{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages.productivity;

  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86;
in
{
  options.packages.productivity = {
    enable = lib.mkEnableOption "Packages for productivity";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.zotero
    ];

  };
}
