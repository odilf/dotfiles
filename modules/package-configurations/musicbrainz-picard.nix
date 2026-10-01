{ ... }: {
  home-manager.users."*".home.linkLive.files = {
    ".config/MusicBrainz" = "live/picard";
  };
}
