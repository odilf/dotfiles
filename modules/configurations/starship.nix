{ ... }:
{
  home-manager.sharedModules = [
    {
      programs.starship.settings = {
        add_newline = true;
        format = "$directory$vcs$nix_shell$battery$hostname$cmd_duration$status$line_break$character";
        vcs = {
          order = [
            "jj"
            "git"
          ];
          jj_modules = "$jj_change$jj_bookmark$jj_status";
          git_modules = "$git_branch";
        };
        jj_change.format = "$change ";
        jj_bookmark.format = "[$bookmark]($style) ";
        git_branch.format = "[$branch]($style) ";
        status.disabled = false;
        cmd_duration.min_time = 5000;
        hostname = {
          ssh_only = true;
          format = "[$ssh_symbol$hostname]($style) ";
        };
        nix_shell = {
          format = "[❄ ]($style)";
          impure_msg = "";
          pure_msg = "";
        };
        battery.display = [
          {
            threshold = 50;
            style = "bold yellow";
          }
        ];
        character = {
          success_symbol = "[~>](bold green)";
          error_symbol = "[~>](bold red)";
        };
      };
    }
  ];
}
