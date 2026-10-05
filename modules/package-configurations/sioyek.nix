{ ... }:
{
  home-manager.sharedModules = [
    {
      programs.sioyek.config = {
        ui_font = "IosevkaTerm Nerd Font";
        default_dark_mode = "1";
        should_launch_new_window = "1";
        should_draw_unrendered_pages = "1";
        inverse_search_command = "$EDITOR %1:%2";

        create_table_of_contents_if_not_exists = "1";
        max_created_toc_size = "5000";
        super_fast_search = "1";

        # https://github.com/ahrm/sioyek/issues/1488
        # Available since Oct 17, 2025, but sioyek has no releases since Dec 16, 2022 :(
        # but nixpkgs packages an unstable version! I <3 nix ^^
        open_last_file_on_startup = "1";
      };
    }
  ];
}
