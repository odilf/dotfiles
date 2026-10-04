{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  utils = import ../utils.nix { inherit config lib pkgs; };
in
{
  home-manager.users."*" =
    { hmConfig, ... }:
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

      home.packages = lib.mkIf hmConfig.programs.alacritty.enable [
        pkgs.ueberzugpp
      ];
    };

  fonts.packages = lib.mkIf (utils.programEnabled "alacritty") [
    pkgs.nerd-fonts.iosevka-term
  ];

  custom.theme-switch.hooks = lib.mkIf (utils.programEnabled "alacritty") [
    # -f is needed otherwise we get permission errors.
    ''
      if [[ "$THEME_MODE" == "dark" ]]; then
        cp -f ${../../themes/alacritty/flatblack.toml} $HOME/.config/alacritty/theme.toml
      else
        cp -f ${../../themes/alacritty/flatwhite.toml} $HOME/.config/alacritty/theme.toml
      fi
    ''
  ];
}
