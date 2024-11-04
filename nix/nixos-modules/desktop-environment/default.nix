{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.desktop-environment;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  imports = [
    ./linux.nix
    ./darwin.nix
  ];

  options.desktop-environment = {
    enable = lib.mkEnableOption "Desktop environment";
  };

  config = {
    environment.systemPackages = [
      pkgs.qalculate-qt
    ];
  };
}
