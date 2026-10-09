{ ... }:
{
  home-manager.sharedModules = [
    (
      { config, lib, ... }:
      {
        programs.git = {
          settings = {
            user.email = "odysseas.maheras@gmail.com";
            user.name = "odilf";
            pull.rebase = true;
            credential.helper = "cache";
            rerere.enabled = true; # Resuse Recorded Resulution
            fetch.prune = true;
            gpg.format = "ssh";
            user.signingkey = "~/.ssh/id_ed25519.pub";
          };

          # Old home stateVersion
          signing.format = null;
        };

        programs.delta = lib.mkIf config.programs.git.enable {
          enable = true;
          enableGitIntegration = true;
        };
      }
    )
  ];
}
