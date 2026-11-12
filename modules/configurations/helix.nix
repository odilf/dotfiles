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
          # package = pkgs.steelix.override { inherit helix-unwrapped; };
          package = pkgs.steelix;
          settings = {
            theme = "base16_default";

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
            language-server.scls = {
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
              environment = {
                RUST_LOG = "info,simple-completion-language-server=info";
                LOG_FILE = "/tmp/completion.log";
              };
            };

            language-server.rust-analyzer.environment.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc
            }";

            language = lib.mapAttrsToList (name: value: { inherit name; } // value) {
              nix = {
                auto-format = true;
                formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
              };

              scls = {
                scope = "text.scls";
                file-types = [ ];
                shebangs = [ ];
                roots = [ ];
                auto-format = false;
                language-servers = [ "scls" ];
              };
              markdown.language-servers = [
                "marksman"
                "markdown-oxide"
                "scls"
              ];
            };
          };
        };

        # Should arguably be in project devShells, but are convinient to always have
        home.packages = [
          pkgs.cargo
          pkgs.rust-analyzer
          pkgs.rustfmt
          pkgs.clippy
          pkgs.rustc
          pkgs.bacon

          pkgs.nil
          pkgs.nixd
          pkgs.taplo
          pkgs.marksman
          pkgs.uv
          pkgs.ruff
          pkgs.ty
          pkgs.vscode-langservers-extracted
          pkgs.tinymist
        ];

        xdg = lib.mkIf config.programs.helix.enable {
          configFile = {
            "helix/unicode-input/base.toml".source = ./helix/unicode-input.toml;
            "helix/themes/".source = ./helix/themes;
            "helix/init.scm".text = ''
              (require "context/context.scm")
              (context-enable 'right)
              (require "zen-mode/zen-mode.scm")
              (require "helix-discord-rpc/init.scm")
              (discord-rpc-connect)
            '';
          };

          dataFile =
            let
              ext = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
            in
            {
              "steel/cogs/context".source = pkgs.helix-plugins.context;
              "steel/cogs/zen-mode".source = pkgs.helix-plugins.zen-mode;
              "steel/cogs/helix-discord-rpc".source = pkgs.helix-plugins.helix-discord-rpc;
              "steel/native/libhelix_discord_rpc${ext}".source =
                "${pkgs.helix-plugins.helix-discord-rpc}/native/libhelix_discord_rpc${ext}";
            };
        };

        home.sessionVariables.EDITOR = lib.mkIf config.programs.helix.enable "hx";
      }
    )
  ];
}
