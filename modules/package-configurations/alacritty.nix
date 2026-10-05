{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  alacrittyEnabled = lib.any (user: config.home-manager.users.${user}.programs.alacritty.enable) (
    builtins.attrNames config.home-manager.users
  );

  homeConfig =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.alacritty.theme = "enfocado_dark";
      programs.alacritty.settings = {
        # general.import = [ "theme.toml" ];
        terminal.shell = "${pkgs.fish}/bin/fish";

        # TODO: It's really important to disable font smoothing on macos for
        # this to look right. This should be in the config somewhere.
        font.size = if isDarwin then 18.0 else 14.0;
        font.normal.family = "IosevkaTerm Nerd Font";
        font.normal.style = "Regular";

        window = {
          opacity = 0.90;
          decorations = if isDarwin then "buttonless" else "none";
          dynamic_title = true;
          option_as_alt = "OnlyLeft";
        };

        keyboard.bindings = [
          {
            key = "N";
            mods = "Control|Shift";
            action = "CreateNewWindow";
          }
          {
            key = "Return";
            mods = "Alt";
            action = "CreateNewWindow";
          }
        ];
      };

      home.packages = lib.mkIf config.programs.alacritty.enable [
        pkgs.ueberzugpp
      ];
    };
in
{
  fonts.packages = lib.mkIf alacrittyEnabled [
    pkgs.nerd-fonts.iosevka-term
  ];

  custom.theme-switch.hooks = lib.mkIf alacrittyEnabled [
    # -f is needed otherwise we get permission errors.
    ''
      if [[ "$THEME_MODE" == "dark" ]]; then
        cp -f ${../../themes/alacritty/flatblack.toml} $HOME/.config/alacritty/theme.toml
      else
        cp -f ${../../themes/alacritty/flatwhite.toml} $HOME/.config/alacritty/theme.toml
      fi
    ''
  ];

  home-manager.sharedModules = [ homeConfig ];
}
