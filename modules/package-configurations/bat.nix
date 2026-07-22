{ ... }:
{
  home-manager.users."*".programs.bat.config = {
    plain = true;
  };

  # TODO: Watch out... this is global, actually.
  environment.variables.PAGER = "bat";
}
