{ pkgs, lib, config, ... }:
let 
  cfg = config.packages;
in
{
  imports = [
    ./games.nix
    ./development.nix
  ];

  options = {
    packages.gui = lib.mkEnableOption "gui";
    packages.browser = lib.mkOption {
      type = lib.types.package;
      default = pkgs.firefox;
    };
  };

  config = {
    packages.development.enable = lib.mkDefault true;

    # Always include a text editor, and a browser in GUIs.
    environment.systemPackages = with pkgs; [
      vim
    ] ++ lib.optionals cfg.gui [
      cfg.browser
    ];
  };
}
