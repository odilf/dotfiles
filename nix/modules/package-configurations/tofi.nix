{ pkgs, ... }:
{
  home-manager.users."*" = {
    programs.tofi = {
      settings = {
        # Window dimensions and positioning
        width = "100%";
        height = "100%";
        border-width = 2;
        outline-width = 0;
        padding-left = "43%";
        padding-top = "15%";

        # Results
        result-spacing = 15;
        num-results = 8;

        # Font
        font = "${pkgs.nerd-fonts.iosevka-term}/share/fonts/truetype/NerdFonts/IosevkaTermNerdFontMono-Regular.ttf";
        font-size = 16;

        # Behavior
        hide-cursor = true;
        history = true;
        fuzzy-match = true;

        # Performance
        drun-launch = true;
        terminal = "alacritty"; # adjust to your terminal
      };
    };
  };
}
