{ ... }:
{
  home-manager.users."*".programs.bat.config = {
    theme = "TwoDark";
  };

  # TODO: Watch out... this is global, actually.
  environment.variables.PAGER = "bat";
}
