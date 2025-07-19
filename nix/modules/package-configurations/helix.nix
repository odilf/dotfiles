{
  pkgs,
  ...
}:
{
  home-manager.users."*" = {
    programs.helix = {
      enable = true;
      settings = {
        # Alternative options for themes:
        # Non-underline errors: ["ao", "iroaseta", "vim_dark_high_contrast", "yo", "yo_berry", "zenburn"]
        # Nice looking: ["starlight"]
        theme = "base16_default";

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

        # Open yazi in helix
        keys.normal = {
          C-y = [
            ":sh rm -f /tmp/unique-file"
            ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
            ":insert-output echo \"\x1b[?1049h\x1b[?2004h\" > /dev/tty"
            ":open %sh{cat /tmp/unique-file}"
            ":redraw"
            # Fix mouse (but I don't really care)
            ":set mouse false"
            ":set mouse true"
          ];
        };
      };

      languages = {
        language-server.scls = {
          command = "simple-completion-language-server";
          config = {
            max_completion_items = 100; # set max completion results len for each group: words, snippets, unicode-input
            feature_words = false; # enable completion by word
            feature_snippets = false; # enable snippets
            snippets_first = true; # completions will return before snippets by default
            snippets_inline_by_word_tail = false; # suggest snippets by WORD tail, for example text `xsq|` become `x^2|` when snippet `sq` has body `^2`
            feature_unicode_input = true; # enable "unicode input"
            feature_paths = false; # enable path completion
            feature_citations = false; # enable citation completion (only on `citation` feature enabled)
          };

          # write logs to /tmp/completion.log
          environment = {
            RUST_LOG = "info,simple-completion-language-server=info";
            LOG_FILE = "/tmp/completion.log";
          };
        };

        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          }
          {
            name = "scls";
            scope = "text.scls";
            file-types = [ ];
            shebangs = [ ];
            roots = [ ];
            auto-format = false;
            language-servers = [ "scls" ];
          }
          {
            name = "markdown";
            language-servers = [
              "marksman"
              "markdown-oxide"
              "scls"
            ];
          }
        ];
      };
    };

    xdg.configFile."helix/unicode-input/base.toml".source = ./helix/unicode-input.toml;
  };

  # TODO: Watch out... this is global, actually.
  environment.variables."EDITOR" = "hx";
}
