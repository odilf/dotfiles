{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  toggleAppearance =
    if isDarwin then
      ''osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode' ''
    else
      # Read freedesktop color-scheme and toggle it.
      ''
        current=$(${pkgs.glib}/bin/gsettings get org.gnome.desktop.interface color-scheme)
        if [[ "$current" == *dark* ]]; then
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme prefer-light
        else
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme prefer-dark
        fi
      '';

  toggle-theme = pkgs.writeShellScriptBin "toggle-theme" ''
    ${toggleAppearance}
    ${lib.concatStringsSep "\n" config.custom.theme-switch.hooks}
  '';
in
{
  custom.theme-switch.package = toggle-theme;

  home-manager.users."*".home.packages = [ toggle-theme ];
}
