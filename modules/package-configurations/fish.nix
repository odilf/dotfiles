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

      nix-index.enable = true;

      direnv.enable = true;
      direnv.nix-direnv.enable = true;
    };

    home.packages = [ pkgs.comma ];

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

      # Adapted from https://gist.github.com/jarun/4f7f3fba4618054d999463f242a4b5b9
      functions."fish_right_prompt".body =
        let
          notify =
            body:
            if pkgs.stdenv.hostPlatform.isLinux then
              "${pkgs.libnotify}/bin/notify-send (echo ${body})"
            else
              "echo $body | ${lib.getExe pkgs.terminal-notifier} -title 'Finished command'";
        in
        ''
          if test $CMD_DURATION
            # Show notification if dration is more than 5 seconds
            if test $CMD_DURATION -gt 5000
              # Show duration of the last command in seconds
              set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
              ${notify "(history | head -1) returned $status after $duration"}
            end
          end
        '';
    };
  };

  users.users."*".shell = lib.mkIf config.programs.fish.enable pkgs.fish;
  environment.variables.SHELL = "fish";
}
