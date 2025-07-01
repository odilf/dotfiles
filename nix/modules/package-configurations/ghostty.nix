{ pkgs, ... }:
{
  home-manager.users."*".programs.ghostty = {
    package = null;
    settings = {
      font-family = "IosevkaTerm Nerd Font";
      font-style = "Regular";
      command = "${pkgs.fish}/bin/fish";
      theme =
        let
          light = "BlulocoLight";
          dark = "carbonfox";
        in
        "light:${light},dark:${dark}";
      font-size = 16;
      window-decoration = "none";
      macos-option-as-alt = "left";
      adjust-underline-thickness = 1;

      quit-after-last-window-closed = true;
      macos-window-shadow = false;
      mouse-hide-while-typing = true;
      background-opacity = 0.9;
      background-blur = true;
    };
  };
}
