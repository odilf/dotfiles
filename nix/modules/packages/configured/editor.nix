{
  lib,
  config,
  pkgs,
  ...
}:
let
  utils = import ../../utils.nix { inherit lib pkgs config; };
  cfg = config.packages.configured.editor;
in
{
  options.packages.configured.editor = {
    enable = lib.mkEnableOption "editor";

  };

  config = lib.mkIf cfg.enable (
    utils.eachHome {
      xdg.configFile.nvim.source = ../../../../nvim;

      programs.helix = {
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

      programs.neovim = {
        enable = true;
        extraPackages = [
          pkgs.deno # For Peek.nvim
          pkgs.nodejs_latest # For copilot and perhaps something else
        ];
      };
    }
    // {
      environment.variables."EDITOR" = "hx";
    }
  );
}
