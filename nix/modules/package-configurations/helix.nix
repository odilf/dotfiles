{
  pkgs,
  ...
}:
{
  home-manager.users."*".programs.helix = {
    enable = true;
    settings = {
      # Alternative options for themes:
      # Non-underline errors: ["ao", "iroaseta", "vim_dark_high_contrast", "yo", "yo_berry", "zenburn"]
      # Nice looking: ["starlight"]
      theme = "vim_dark_high_contrast";

      editor = {
        # auto-info = false;
        line-number = "relative";
        end-of-line-diagnostics = "hint";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        completion-timeout = 5;
        completion-trigger-len = 1;

        auto-save.focus-lost = true;
        inline-diagnostics.cursor-line = "warning";

      };
    };

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
      ];
    };
  };

  # TODO: Watch out... this is global, actually.
  environment.variables."EDITOR" = "hx";
}
