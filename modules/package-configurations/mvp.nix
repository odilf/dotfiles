{ ... }: {
  home-manager.users."*".programs.mpv = {
    config = {
      keep-open = true;
    };
  };
}
