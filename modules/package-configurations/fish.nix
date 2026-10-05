{
  pkgs,
  config,
  lib,
  ...
}:
let
  utils = import ../utils.nix { inherit config lib pkgs; };
in
{
  home-manager.users."*" =
    { hmConfig, ... }:
    {
      xdg.configFile."fish/completions/nix.fish" = lib.mkIf hmConfig.programs.fish.enable {
        # TODO: I don't think this is necessary, remove this.
        # Maybe necessary for completions? (https://discourse.nixos.org/t/how-to-use-completion-fish-with-home-manager/23356/3)
        source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";
      };

      programs = lib.mkIf hmConfig.programs.fish.enable {
        eza.enable = true;
        eza.enableFishIntegration = false; # `la` does `eza -a` but I want `eza -l`

        zoxide.enable = true;
        starship.enable = true;

        nix-index.enable = true;
        nix-index.enableFishIntegration = false; # takes a long time to fail commands otherwise

        navi.enable = true;

        direnv.enable = true;
        direnv.nix-direnv.enable = true;

        fish = {
          preferAbbrs = true;
          interactiveShellInit = ''
            set fish_greeting
            enable_transience # (from starship)

            # Append brew path on darwin.
            switch (uname)
              case "Darwin"
                set -x PATH $PATH /opt/homebrew/bin/
            end

            ${lib.getExe pkgs.pfetch-rs}
          '';

          shellAbbrs = {
            # Keep muscle memmory but use new versions
            ls = "eza";
            la = "eza -l";
            lt = "eza --tree";
            grep = "rg";
            cat = "bat";

            # Actual abbreviations of long commands
            e = "$EDITOR";
            g = "git";
            c = "cargo";
            o = "open \\$argv &; disown";
            j = "jj";

            ## Git
            gc = "git commit";
            gC = "git commit --amend";
            gp = "git push";
            gP = "git pull";
            gl = "git log --graph";
            gd = "git diff";
            gD = "git diff --staged";
            gs = "git status";

            jc = "jj commit";
            jd = "jj diff";
            js = "jj st";

            ## Nix
            ns = "nix shell nixpkgs#";
          };
        };
      };

      home.packages = lib.mkIf hmConfig.programs.fish.enable [ pkgs.comma ];
    };

  users.users."*" =
    { hmConfig, ... }:
    {
      shell = lib.mkIf hmConfig.programs.fish.enable pkgs.fish;
    };

  programs.fish.enable = lib.mkIf (utils.programEnabled "fish") true;
}
