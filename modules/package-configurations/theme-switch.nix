{
  pkgs,
  lib,
  config,
  ...
}:
let
  toggle-theme = pkgs.writeShellScriptBin "toggle-theme" ''
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
    ${lib.concatStringsSep "\n" config.custom.theme-switch.hooks}
  '';
in
{
  custom.theme-switch.package = toggle-theme;

  home-manager.users."*".home.packages = [ toggle-theme ];
}
