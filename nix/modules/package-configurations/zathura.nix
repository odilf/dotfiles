{ ... }:
{
  home-manager.users."*".programs.zathura = {
    options = {
      adjust-open = "best-fit";
      smooth-scroll = "true";
      font = "IosevkaTerm Nerd Font 13";
      recolor = "true";
      recolor-lightcolor = "#000000";
      recolor-darkcolor = "#E0E0E0";
      recolor-reverse-video = "true";
      recolor-keephue = "true";
    };
    mappings = {
      "<Esc>" = "";
    };
  };
}
