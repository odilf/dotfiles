{
  pkgs,
  lib,
  ...
}:
{
  home-manager.users."*" =
    { hmConfig, ... }:
    let
      ini-file = "${hmConfig.xdg.configHome}/MusicBrainz/Picard.ini";

      # Only the settings you've actually changed from Picard's defaults.
      # Everything else is left at its default (see the inventory below).
      settings = {
        acousticbrainz_add_keybpm = true;
        acousticbrainz_add_fullhighlevel = true;
        acousticbrainz_add_sublowlevel = true;
        check_for_updates = true;
        enabled_plugins = "acousticbrainz, acousticbrainz_tonal-rhythm, amazon, deezerart, instruments, lastfm, musixmatch";
        file_save_warning = false;
        lastfm_use_artist_tags = true;
        lastfm_use_track_tags = true;
        move_files = true;
        move_files_to = "/Users/odilf/uoh-library/music";
        preferred_release_countries = "XW, XE";
        save_images_to_files = true;
        show_new_user_dialog = false;
        use_genres = true;
      };

      # Convert a Nix value to the string Picard expects in the ini.
      toIniValue = v: if builtins.isBool v then (if v then "true" else "false") else toString v;

      crudiniArgs = lib.concatMapStringsSep " " (
        { name, value }: "--set \"$INI\" setting '${name}' '${toIniValue value}'"
      ) (lib.attrsToList settings);
    in
    {
      home.activation.musicbrainzPicard = hmConfig.lib.dag.entryAfter [ "writeBoundary" ] ''
        INI="${ini-file}"
        $DRY_RUN_CMD mkdir -p "$(dirname "$INI")"
        $DRY_RUN_CMD ${pkgs.crudini}/bin/crudini --ini-options=nospace --del "$INI" setting ${crudiniArgs}
      '';
    };
}
