{
  lib,
  config,
  pkgs,
  ...
}:
let
  utils = import ../../utils.nix { inherit lib pkgs config; };
  cfg = config.packages.configured.git;
in
{
  options.packages.configured.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf cfg.enable (
    utils.eachHome {
      programs.git = {
        enable = true;
        delta.enable = true;
        userEmail = "odysseas.maheras@gmail.com";
        userName = "odilf";
        extraConfig = {
          pull.rebase = true;
          credential.helper = "cache";
          rerere.enabled = true; # Resuse Recorded Resulution
          fetch.prune = true;
          gpg.format = "ssh";
          user.signingkey = "~/.ssh/id_ed25519.pub";
        };
      };
    }
  );
}
