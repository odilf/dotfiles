# TODO: This doesn't work for arm, so I don't care for now...
{
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isx86_64;
  # TODO: Actually detect if reaper is enabled
  enabled = false;
in
lib.mkIf (isx86_64 && enabled) {
  # Enable 32-bit support (required for many Windows VSTs)
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # Audio setup
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # System packages
  environment.systemPackages = [
    # Reaper
    pkgs.reaper

    # yabridge for Windows VST support
    pkgs.yabridge
    pkgs.yabridgectl

    # Wine staging (better audio support)
    pkgs.wineWow64Packages.staging
    pkgs.winetricks

    # Useful audio tools
    pkgs.qjackctl # JACK control GUI
    pkgs.carla # Plugin host (optional, useful for testing)
  ];

  # Add your user to audio group
  # TODO: Do with mapUsers
  users.users.odilf = {
    extraGroups = [ "audio" ];
  };

  # Environment variables for yabridge
  environment.variables = {
    # Point yabridge to Wine
    WINEPREFIX = "$HOME/.wine-vst";
  };

  # Optional: realtime audio privileges
  security.pam.loginLimits = [
    {
      domain = "@audio";
      type = "-";
      item = "rtprio";
      value = "99";
    }
    {
      domain = "@audio";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "@audio";
      type = "-";
      item = "nice";
      value = "-19";
    }
  ];
}
