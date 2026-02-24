{
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  home-manager.users."*" = {
    programs.alacritty = {
      settings = {
        terminal.shell = "${pkgs.fish}/bin/fish";

        font.size = if isDarwin then 16.0 else 12.0;
        font.normal.family = "IosevkaTerm Nerd Font";
        font.normal.style = "Regular";

        window = {
          decorations = "none";
          dynamic_title = true;
          option_as_alt = "OnlyLeft";
        };

        keyboard.bindings = [
          {
            key = "N";
            mods = "Control|Shift";
            action = "CreateNewWindow";
          }
        ];
      };
    };

    home.packages = [
      pkgs.ueberzugpp
    ];
  };

  fonts.packages = [
    pkgs.nerd-fonts.iosevka-term
  ];
}
