{ ... }:
{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        helix-unwrapped = pkgs.helix-unwrapped.overrideAttrs (old: {
          prePatch = (old.prePatch or "") + ''
            patch -p1 --directory="$PWD" < ${./helix/osc11-zellij.patch}
          '';
        });
      in
      {
        programs.helix = {
          package = pkgs.steelix.override { inherit helix-unwrapped; };
          settings = {
            theme = "base16_transparent";

            editor = {
              line-number = "relative";
              end-of-line-diagnostics = "hint";
              cursor-shape = {
                insert = "bar";
                normal = "block";
                select = "underline";
              };

              soft-wrap.enable = true;

              completion-timeout = 5;
              completion-trigger-len = 1;

              auto-save.focus-lost = true;
              inline-diagnostics.cursor-line = "warning";

              lsp.display-progress-messages = true;
            };

            # Open yazi in helix
            keys.normal = {
              C-y = [
                ":sh rm -f /tmp/unique-file"
                ":insert-output yazi \"%{buffer_name}\" --chooser-file=/tmp/unique-file"
                ":sh printf \"\\x1b[?1049h\\x1b[?2004h\" > /dev/tty"
                ":open %sh{cat /tmp/unique-file}"
                ":redraw"
                # Fix mouse (but I don't really care)
                ":set mouse false"
                ":set mouse true"
              ];
            };
          };

          languages = {
            language-server = {
              scls = {
                command = "simple-completion-language-server";
                config = {
                  max_completion_items = 100;
                  feature_words = false;
                  feature_snippets = false;
                  snippets_inline_by_word_tail = false;
                  feature_unicode_input = true;
                  feature_paths = false;
                  feature_citations = false;
                };

                # write logs to /tmp/completion.log
                environment = {
                  RUST_LOG = "info,simple-completion-language-server=info";
                  LOG_FILE = "/tmp/completion.log";
                };
              };

              tinimyst = {
                command = "${pkgs.tinymist}/bin/tinymist";

                config = {
                  preview.background.enabled = true;
                  preview.background.args = [
                    "--open"
                  ];
                };
              };
            };

            language = [
              {
                name = "nix";
                auto-format = true;
                formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
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
              {
                name = "typst";
                language-servers = [ "tinymist" ];
              }
            ];
          };
        };

        xdg.configFile = lib.mkIf config.programs.helix.enable {
          "helix/unicode-input/base.toml".source = ./helix/unicode-input.toml;
          "helix/themes/".source = ./helix/themes;
        };

        home.sessionVariables.EDITOR = lib.mkIf config.programs.helix.enable "hx";
      }
    )
  ];
}
