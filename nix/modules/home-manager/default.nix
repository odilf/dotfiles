{ lib, config, ... }:
{
  options = {
    odilf.enable = lib.mkEnableOption "odilf user";
    uoh.enable = lib.mkEnableOption "uoh user";
  };

  config = {
    home-manager.users.odilf = lib.mkIf config.odilf.enable (import ./odilf);

    users.users.odilf = lib.mkIf config.odilf.enable {
      name = "odilf";
      isNormalUser = true;
    };

    home-manager.users.uoh = lib.mkIf config.uoh.enable (import ./uoh);
  };
}
