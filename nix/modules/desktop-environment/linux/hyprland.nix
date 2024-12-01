{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop-environment.hyprland;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  options.desktop-environment.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf (config.gui && cfg.enable && isLinux) {
    # nixpkgs.overlays = [
    #   (final: prev:
    #   {
    #     ags = prev.ags.overrideAttrs (old: {
    #       buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
    #     });
    #   })
    # ];

    programs.hyprland.enable = true;
    programs.waybar.enable = true;
    programs.hyprlock.enable = true;

    services.hypridle.enable = true;

    environment.systemPackages = [
      pkgs.tofi
      pkgs.hyprpaper
    ];

    # programs.ags.enable = true;

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };

    # services.displayManager.sddm.enable = true;
    # services.displayManager.sddm.wayland.enable = true;
  };
}
