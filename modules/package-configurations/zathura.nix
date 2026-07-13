{ ... }:
{
  home-manager.users."*".programs.zathura = {
    options = {
      adjust-open = "best-fit";
      font = "IosevkaTerm Nerd Font 12";
      recolor = true;
      recolor-lightcolor = "#000000";
      recolor-darkcolor = "#E0E0E0";
      selection-clipboard = "clipboard";
      recolor-keephue = true;
      incremental-search = true;
      statusbar-home-tilde = true;
      window-title-home-tilde = true;
    };
    mappings = {
      "<Esc>" = "";
    };
  };
}
