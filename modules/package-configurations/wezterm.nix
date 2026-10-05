{ ... }:
{
  home-manager.sharedModules = [
    (
      { lib, pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) isDarwin;

        loadScheme = path: (builtins.fromTOML (builtins.readFile path)).colors;
      in
      {
        programs.wezterm = {
          settings = {
            font = lib.generators.mkLuaInline ''wezterm.font("IosevkaTerm Nerd Font")'';
            font_size = if isDarwin then 16 else 12;
            default_prog = [ "${pkgs.fish}/bin/fish" ];
            # "NONE" also strips the resize border on macOS; "RESIZE" keeps it
            # while still hiding the titlebar.
            window_decorations = "RESIZE";
            enable_tab_bar = false;
            hide_mouse_cursor_when_typing = true;
          };

          colorSchemes = {
            flatwhite = loadScheme ../../themes/wezterm/flatwhite.toml;
            flatblack = loadScheme ../../themes/wezterm/flatblack.toml;
          };

          extraConfig = ''
            wezterm.on('window-config-reloaded', function(window, pane)
              local overrides = window:get_config_overrides() or {}
              local scheme = window:get_appearance():find("Dark") and "flatblack" or "flatwhite"
              if overrides.color_scheme ~= scheme then
                overrides.color_scheme = scheme
                window:set_config_overrides(overrides)
              end
            end)
          '';
        };
      }
    )
  ];
}
