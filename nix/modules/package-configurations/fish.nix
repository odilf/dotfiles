{
  pkgs,
  config,
  lib,
  ...
}:
{
  home-manager.users."*" = {
    # TODO: I don't think this is necessary, remove this.
    # Maybe necessary for completions? (https://discourse.nixos.org/t/how-to-use-completion-fish-with-home-manager/23356/3)
    xdg.configFile."fish/completions/nix.fish".source =
      "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";

    programs = {
      eza.enable = true;
      eza.enableFishIntegration = false; # `la` does `eza -a` but I want `eza -l`

      zoxide.enable = true;
      starship.enable = true;
      pay-respects.enable = true;

      nix-index.enable = true;

      direnv.enable = true;
      direnv.nix-direnv.enable = true;
    };

    programs.fish = {
      preferAbbrs = true;
      interactiveShellInit = ''
        set fish_greeting
        enable_transience # (from starship)

        # Append brew path on darwin.
        switch (uname)
          case "Darwin"
            set -x PATH $PATH /opt/homebrew/bin/
        end

        ${lib.getExe pkgs.pfetch}
        ${lib.getExe pkgs.taskwarrior3}
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
        t = "task";
        tt = "taskwarrior-tui";

        ## Git
        gc = "git commit";
        gC = "git commit --amend";
        gp = "git push";
        gP = "git pull";
        gl = "git log --graph";
        gd = "git diff";
        gD = "git diff --staged";
        gs = "git status";

        ## Nix
        ns = "nix shell nixpkgs#";
      };
    };
  };

  users.users."*".shell = lib.mkIf config.programs.fish.enable pkgs.fish;
  environment.variables.SHELL = "fish";
}
