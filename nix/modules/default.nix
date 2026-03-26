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
