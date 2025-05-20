{
  pkgs,
  ...
}:
{
  home-manager.users."*".programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = "${pkgs.fish}/bin/fish";

      font.size = 16.0;
      font.normal.family = "IosevkaTerm Nerd Font";
      font.normal.style = "Regular";

      # TODO: Review these settings
      window = {
        decorations = "none";
        dynamic_title = true;
        option_as_alt = "OnlyLeft";
        startup_mode = "Maximized";
      };
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.iosevka-term
  ];
}
