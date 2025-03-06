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
    ./configured

    ./games.nix
    ./development.nix
    ./social.nix
    ./fonts.nix
    ./creative.nix
  ];

  options.packages = {
    gui = lib.mkEnableOption "gui";

    users = lib.mkOption {
      description = "List of users to configure";
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = builtins.attrNames config.users.users;
    };

    browser = lib.mkOption {
      description = "Main browser for the system";
      type = lib.types.enum [
        "firefox"
        "firefox-nightly"
      ];
      default = "firefox-nightlty";
    };
  };

  config = {
    packages.development.enable = lib.mkDefault true;
    packages.fonts.enable = lib.mkDefault true;

    # Always include a text editor, and a browser in GUIs.
    environment.systemPackages =
      [
        pkgs.helix
      ]
      ++ lib.optionals (cfg.gui && pkgs.stdenv.hostPlatform.isLinux) [
        # TODO: Make it respect config
        pkgs.firefox-beta
      ];

    homebrew = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      enable = true;
      # onActivation.cleanup = "uninstall";

      # TODO: Make it respect config
      casks = [ "firefox@nightly" ];
    };
  };
}
