{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Custom NixOS options
  # ---

  gui = true;
  desktop-environment = "niri";
  laptop.enable = true;

  custom.bundles.odilf = {
    development.enable = true;
    social.enable = true;
    games.enable = true;
    creative.enable = true;
    productivity.enable = true;
  };

  nix.settings = {
    trusted-users = [ "odilf" ];
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
    ];
  };

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  # Regular NixOS options
  # ---

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  hardware.graphics.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # networking.wireless.network-manager.enable = lib.mkForce false;
  networking.networkmanager.enable = lib.mkForce false;
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  networking.hostName = "nixbook";

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # TODO: Move out of here
  services.kanata = {
    enable = true;
    keyboards.main = {
      config = ''
        (defsrc
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    ret
          caps a    s    d    f    g    h    j    k    l    ;    '    \    ;;ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
              lctl  lalt lmet          spc        rmet ralt 
        )

        (deflayermap (main)
          caps @cap
        )

        (defalias
          cap-inner (tap-hold-press 0 200 esc lctrl)
          cap (multi f24 @cap-inner) ;; workaround https://github.com/jtroo/kanata/discussions/422
        )
      '';

      extraDefCfg = "process-unmapped-keys yes";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.odilf = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
