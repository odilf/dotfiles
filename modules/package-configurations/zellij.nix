{ ... }: {
  home-manager.users."*".programs.zellij = {
    extraConfig = builtins.readFile ./zellij/config.kdl;
  };
}
