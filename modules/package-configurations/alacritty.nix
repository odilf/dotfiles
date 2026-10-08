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

  theme-dark = "enfocado_dark.toml";
  theme-light = "enfocado_light.toml";

  homeConfig =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.alacritty.settings = {
        general.import = [ "theme.toml" ];

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
    {
      # on-dark = "ln -f -s ${pkgs.alacritty-theme}/share/alacritty-theme/${theme-dark} $HOME/.config/alacritty/theme.toml";
      # on-light = "ln -f -s ${pkgs.alacritty-theme}/share/alacritty-theme/${theme-light} $HOME/.config/alacritty/theme.toml";
      on-dark = "cp -f ${pkgs.alacritty-theme}/share/alacritty-theme/${theme-dark} $HOME/.config/alacritty/theme.toml";
      on-light = "cp -f ${pkgs.alacritty-theme}/share/alacritty-theme/${theme-light} $HOME/.config/alacritty/theme.toml";
    }
  ];

  home-manager.sharedModules = [ homeConfig ];
}
