{
  lib,
  ...
}:
{
  imports = [
    ./package-configurations
    ./bundles
    ./desktop-environment
  ];

  options = {
    gui = lib.mkEnableOption "Does the system use a graphical user interface?";
    passthru = lib.mkOption { };
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
