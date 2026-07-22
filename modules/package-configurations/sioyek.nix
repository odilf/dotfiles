{ pkgs, ... }:
{

  home-manager.users."*".programs = {
    sioyek.config = {
      ui_font = "IosevkaTerm Nerd Font";
      default_dark_mode = "1";
      should_launch_new_window = "1";
      inverse_search_command = "$EDITOR %1:%2";
    };
  };
}
