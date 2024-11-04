{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.desktop-environment;
in
{
  config = lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isDarwin) {
    environment.systemPackages =
      [
      ];

    homebrew = {
      casks = [ 
        "sol" # App launcher
        "aerospace" # Window manager
      ];
    };

    services = {
      aerospace = {
        enable = false;
        # settings = lib.traceVal (builtins.fromTOML (builtins.readFile ../../../aerospace/aerospace.toml) // {
        #   alt-enter = "exec-and-forget open -n ${pkgs.alacritty}/Alacritty.app";
        # });
      };

      spacebar = {
        enable = true;
        package = pkgs.spacebar;
        config = {
          clock_format = "%R";
          space_icon_strip = "   ";
          text_font = ''"Helvetica Neue:Bold:12.0"'';
          icon_font = ''"FontAwesome:Regular:12.0"'';
          background_color = "0xff202020";
          foreground_color = "0xffa8a8a8";
          power_icon_strip = " ";
          space_icon = "";
          clock_icon = "";
        };
      };
    };
  };
}
