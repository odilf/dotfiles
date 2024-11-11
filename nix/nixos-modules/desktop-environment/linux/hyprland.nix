{ config, lib, pkgs, ... }: let
  cfg = config.desktop-environment.hyprland;
 inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  options.desktop-environment.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    programs.hyprland.enable = true;

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };
  };
}
