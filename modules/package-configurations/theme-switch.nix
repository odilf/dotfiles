{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  # Toggles the system appearance and exports THEME_MODE=light|dark
  # with the mode that was just switched to, for hooks to branch on.
  toggleAppearance =
    if isDarwin then
      ''
        osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
        if [[ "$(osascript -e 'tell app "System Events" to tell appearance preferences to get dark mode')" == "true" ]]; then
          export THEME_MODE=dark
        else
          export THEME_MODE=light
        fi
      ''
    else
      # Read freedesktop color-scheme and toggle it.
      ''
        current=$(${pkgs.glib}/bin/gsettings get org.gnome.desktop.interface color-scheme)
        if [[ "$current" == *dark* ]]; then
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme prefer-light
          export THEME_MODE=light
        else
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme prefer-dark
          export THEME_MODE=dark
        fi
      '';

  toggle-theme = pkgs.writeShellScriptBin "toggle-theme" ''
    ${toggleAppearance}
    ${lib.concatStringsSep "\n" config.custom.theme-switch.hooks}
  '';
in
{
  custom.theme-switch.package = toggle-theme;

  home-manager.sharedModules = lib.mkIf config.gui [
    {
      home.packages = [ toggle-theme ];
    }
  ];
}
