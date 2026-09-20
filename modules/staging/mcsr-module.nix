{
  lib,
  ...
}:
{
  options.custom.mcsr = {
    enable = lib.mkEnableOption "Minecraft speedrunning tooling (NinjabrainBot, MST, StandardSettings sync)";

    standardsettings = lib.mkOption {
      description = "Prism Launcher instance name -> standardsettings.json to sync into that instance";
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = {
        Ranked = ./standardsettings.json;
      };
    };

    prismInstancesDir = lib.mkOption {
      description = "Prism Launcher instances directory, relative to the home directory";
      type = lib.types.str;
      default = "Library/Application Support/PrismLauncher/instances";
    };
  };
}
