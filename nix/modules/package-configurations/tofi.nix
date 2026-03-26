{ pkgs, ... }:
{
  home-manager.users."*" = {
    programs.tofi = {
      settings = {
        width = "50%";
        height = "50%";
        margin-left = "25%";
        margin-top = "25%";
        border-width = 2;
        outline-width = 0;
        padding-left = 20;
        padding-top = 20;

        result-spacing = 15;
        font = "${pkgs.nerd-fonts.iosevka-term}/share/fonts/truetype/NerdFonts/IosevkaTerm/IosevkaTermNerdFontMono-Regular.ttf";
        font-size = 26;

        history = true;
        terminal = "${pkgs.alacritty}/bin/alacritty";
        drun-launch = true;
      };
    };
  };
}
