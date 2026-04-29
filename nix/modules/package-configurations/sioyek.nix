{ pkgs, ... }:
{

  home-manager.users."*".programs = {
    sioyek.config = {
      ui_font = "IosevkaTerm Nerd Font";
      default_dark_mode = "1";
      should_launch_new_window = "1";
      inverse_search_command = "$EDITOR %1:%2";
    };

    # Synctex
    helix = {
      settings.keys.normal.g.t =
        ":sh sioyek --inverse-search 'hx %%1:%%2' --reuse-window --forward-search-file %{file_path_absolute} --forward-search-line %{cursor_line} &> /dev/null";
      enable = true;
      languages.language = [
        {
          name = "latex";
          language-servers = [ "texlab" ];
        }
      ];
      languages.language-server.texlab.config.texlab = {
        build = {
          executable = "latexmk";
          args = [
            "-pdf"
            "-interaction=nonstopmode"
            "-synctex=1"
            "-shell-escape"
            "%f"
          ];
          forwardSearchAfter = true;
          onSave = true;
        };
        chktex = {
          onEdit = true;
          onOpenAndSave = true;
        };
        forwardSearch = {
          executable = "sioyek";
          args = [
            "--synctex-forward"
            "%l:%c:%f"
            "%p"
          ];
        };
      };
    };
  };
}
