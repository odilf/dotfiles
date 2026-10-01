{ config, lib, ... }:
let
  cfg = config.home.linkLive;
in
{
  options.home.linkLive = {
    repoPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Absolute path of the dotfiles checkout. When set, configs are symlinked
        out-of-store to the live checkout; when null, no files are linked, so
        importing this flake elsewhere doesn't break.
      '';
    };

    files = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Map of $HOME-relative target path to repo-relative source path. Sources
        are resolved against `repoPath` when set.

        NOTE: prefer to link directories rather than files. 
      '';
    };
  };

  config.home.file = lib.mkIf (cfg.repoPath != null) (
    lib.mapAttrs (target: src: {
      source = config.lib.file.mkOutOfStoreSymlink "${cfg.repoPath}/${src}";
    }) cfg.files
  );
}
