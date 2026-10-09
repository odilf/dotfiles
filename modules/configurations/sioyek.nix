{ pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  # https://github.com/NixOS/nixpkgs/pull/566097/changes
  pkg =
    if isDarwin then
      pkgs.sioyek.overrideAttrs (_: {
        postInstall = ''
          mkdir -p sioyek.app/Contents/Resources
          cp -r pdf_viewer/shaders sioyek.app/Contents/Resources/shaders
          cp pdf_viewer/{prefs,prefs_user,keys,keys_user}.config tutorial.pdf sioyek.app/Contents/Resources/

          mkdir -p $out/Applications $out/bin
          cp -r sioyek.app $out/Applications
          ln -s $out/Applications/sioyek.app/Contents/MacOS/sioyek $out/bin/sioyek
        '';
      })
    else
      pkgs.sioyek;
in
{
  home-manager.sharedModules = [
    {
      programs.sioyek.package = pkg;
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
