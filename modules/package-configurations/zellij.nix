{ ... }: {
  home-manager.users."*" = {
    programs.zellij.extraConfig = builtins.readFile ./zellij/config.kdl;

    # Name new sessions after the current directory by default.
    programs.fish.functions."zellij".body = ''
      if test (count $argv) -eq 0
        set session (basename $PWD)
        if test -z "$session" -o "$session" = "/"
          set session default
        end
        command zellij attach --create "$session"
      else
        command zellij $argv
      end
    '';

  };
}
