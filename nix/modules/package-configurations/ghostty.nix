{ pkgs, ... }:
{
  home-manager.users."*".programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      font-family = "IosevkaTerm Nerd Font";
      font-style = "Regular";
      command = "${pkgs.fish}/bin/fish";
      theme =
        let
          light = "Builtin Solarized Light";
          dark = "carbonfox";
        in
        "light:${light},dark:${dark}";
      font-size = 16;
      window-decoration = "none";
      macos-option-as-alt = "left";
      adjust-underline-thickness = 1;
    };
  };
}
