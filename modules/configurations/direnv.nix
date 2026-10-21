{ ... }: {
  home-manager.sharedModules = [
    {
      programs = {
        direnv.nix-direnv.enable = true;

        git.ignores = [
          ".direnv"
          ".envrc"
        ];
      };
    }
  ];
}
