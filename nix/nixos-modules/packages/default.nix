{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages;
in
{
  imports = [
    ./games.nix
    ./development.nix
    ./social.nix
  ];

  options.packages = {
    gui = lib.mkEnableOption "gui";
    browser = lib.mkOption {
      type = lib.types.enum [
        "firefox"
        "firefox-nightly"
      ];
      default = "firefox-nightlty";
    };
  };

  config = {
    packages.development.enable = lib.mkDefault true;

    # Always include a text editor, and a browser in GUIs.
    environment.systemPackages =
      [
        pkgs.vim
      ]
      ++ lib.optionals (cfg.gui && pkgs.stdenv.hostPlatform.isLinux) [
        # TODO: Make it respect config 
        pkgs.firefox-beta
      ];

    homebrew = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      # TODO: Make it respect config 
      casks = [ "firefox@nightly" ];
    };
  };
}
