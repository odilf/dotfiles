{
  config,
  lib,
  ...
}:
lib.mkIf (config.gui && config.desktop-environment == "niri") {
  programs.niri.enable = true;
  services.displayManager = {
    cosmic-greeter.enable = true;
  };
}
