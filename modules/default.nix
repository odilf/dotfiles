{
  lib,
  ...
}:
{
  imports = [
    ./package-configurations
    ./bundles
    ./desktop-environment
    ./services
  ];

  options = {
    gui = lib.mkEnableOption "Does the system use a graphical user interface?";
    passthru = lib.mkOption { };

    custom.flake-path = lib.mkOption {
      description = "Path of current flake";
      type = lib.types.nullOr lib.types.str;
      example = "~/code/dotfiles#nixbook";
      default = null;
    };

    custom.theme-switch.hooks = lib.mkOption {
      description = "Snippets to run when switching themes";
      type = lib.types.listOf lib.types.lines;
      default = [ ];
    };

    custom.theme-switch.package = lib.mkPackageOption pkgs "theme-switcher" {
      # Set in `theme-switcher.nix`
      default = null;
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "reaper"
        "clonehero"
      ];
  };
}
