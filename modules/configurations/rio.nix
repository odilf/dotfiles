{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  rioEnabled = lib.any (user: config.home-manager.users.${user}.programs.rio.enable) (
    builtins.attrNames config.home-manager.users
  );

  theme-dark = "${pkgs.alacritty-theme}/share/alacritty-theme/enfocado_dark.toml";
  theme-light = "${pkgs.alacritty-theme}/share/alacritty-theme/enfocado_light.toml";

  # Converts an alacritty-theme file to rio's flat [colors] table: primary
  # moves up, bright colors become light-*.
  mkRioTheme =
    file:
    let
      colors = (fromTOML (builtins.readFile file)).colors;
    in
    {
      colors =
        colors.primary
        // colors.normal
        // lib.mapAttrs' (name: value: lib.nameValuePair "light-${name}" value) colors.bright;
    };

  homeConfig =
    { ... }:
    {
      programs.rio = {
        settings = {
          adaptive-theme = {
            light = "enfocado-light";
            dark = "enfocado-dark";
          };

          fonts = {
            size = 18.0;
            family = "IosevkaTerm Nerd Font";
            features = [
              "calt=0"
            ];
          };

          window = {
            opacity = 0.90;
            decorations = if isDarwin then "buttonless" else "disabled";
          };

          option-as-alt = "left";

          bindings.keys = [
            {
              key = "n";
              "with" = "control|shift";
              action = "CreateWindow";
            }
            {
              key = "return";
              "with" = "alt";
              action = "CreateWindow";
            }
          ];

          effects = {
            trail-cursor = true;
            trail-cursor-color = "#F07178";
            trail-cursor-opacity = 0.6;
            trail-cursor-decay = [
              50
              150
            ];
            trail-cursor-start-threshold = 2;
          };

          hints = {
            alphabet = "jfkdls;ahgurieowpq";

            # URL hint example
            rules = [
              {
                regex = "(https://|http://)[^\u{0000}-\u{001F}\u{007F}-\u{009F}<>\"\\s{-}\\^⟨⟩`\\\\]+";
                hyperlinks = true;
                post-processing = true;
                persist = false;
                action.command = "xdg-open";
                binding = {
                  key = "O";
                  mods = [
                    "Control"
                    "Shift"
                  ];
                };
              }
            ];
          };

          navigation = {
            mode = "Plain";
            use-split = false;
          };

          # Adjusted by hand to remove window padding in niri...
          margin = [
            (-4)
            (-2)
            0
            (-2)
          ];
        };

        themes = {
          enfocado-dark = mkRioTheme theme-dark;
          enfocado-light = mkRioTheme theme-light;
        };
      };
    };
in
{
  fonts.packages = lib.mkIf rioEnabled [
    pkgs.nerd-fonts.iosevka-term
  ];

  home-manager.sharedModules = [ homeConfig ];
}
