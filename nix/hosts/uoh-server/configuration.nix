# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
    "hfsplus"
    "ext4"
  ];

  # Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "uoh"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = lib.mkDefault false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.uoh = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  environment = {
    # variables = {
    #   EDITOR = "nvim";
    #   SHELL = "fish";
    # };
  };

  programs = {
    # fish.enable = true;

    mosh = {
      enable = true;
      openFirewall = true;
    };
  };

  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      openFirewall = true;
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "uoh" ];
        UseDns = true;
        X11Forwarding = lib.mkDefault false;
        PermitRootLogin = "prohibit-password";
      };
    };

    samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          "use sendfile" = true;
          "hosts deny" = [ "0.0.0.0/0" ];
          "hosts allow" = [
            "192.168.0."
            "127.0.0.1"
            "localhost"
          ];
        };

        "UOH-ARCHIVE" = {
          path = "/mnt/UOH-ARCHIVE";
          browseable = true;
          "valid users" = [
            "odilf"
            "uoh"
          ];
          "read only" = false;
          writeable = true;
          "fruit:nfs_aces" = true;
          "fruit:aapl" = true;
          "vfs objects" = "fruit streams_xattr";
          "fruit:model" = "MacSamba";
        };

        "mnt" = {
          path = "/mnt";
          browseable = true;
          "valid users" = [
            "odilf"
            "uoh"
          ];
          "read only" = true;
          writeable = true;
          "fruit:nfs_aces" = true;
          "fruit:aapl" = true;
          "vfs objects" = "fruit streams_xattr";
          "fruit:model" = "MacSamba";
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    inadyn = {
      enable = true;
      configFile = /etc/inadyn.conf;
    };

    jellyfin = {
      enable = true;
      # logDir = /home/uoh/.config/jellyfin/data;
      # cacheDir = /home/uoh/.config/jellyfin/cache;
      # dataDir = /home/uoh/.config/jellyfin/data;
      # configDir = /home/uoh/.config/jellyfin;
    };

    # immich = {
    #   enable = true;
    #   database.user = "postgres";
    #   database.name = "immich";
    #   database.createDB = false;
    # };
  };

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Open ports in the firewall.
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
      ];
      allowPing = true;
    };
  };

  fileSystems = {
    "/mnt/UOH-ARCHIVE" = {
      device = "/dev/disk/by-uuid/65B5-2A38";
      fsType = "exfat";
      options = [
        "nofail"
        "uid=1000"
        "gid=1000"
        "dmask=007"
        "fmask=117"
        "x-gvfs-show"
      ];
    };

    "/mnt/TOSHIBA" = {
      device = "/dev/disk/by-uuid/2f764760-62d4-427e-b33d-b08ae3fcc5b7";
      fsType = "ext4";
      options = [
        "nofail"
        "rw"
      ];
    };

    "/mnt/UOH-MEDIA" = {
      device = "/dev/disk/by-uuid/89bb9652-c89b-40a5-9a76-7e64212b82f0";
      fsType = "btrfs";
      options = [ "nofail" ];
    };

    "/mnt/INTENSO" = {
      device = "/dev/disk/by-uuid/0dfd1ee6-692f-4911-8f84-341a9aa75f4a";
      fsType = "btrfs";
      options = [ "nofail" ];
    };
  };

  # system = {
  #   autoUpgrade.enable = true;
  #   autoUpgrade.allowReboot = false;
  #   autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable/";
  #
  #   # Copy the NixOS configuration file and link it from the resulting system
  #   # (/run/current-system/configuration.nix). This is useful in case you
  #   # accidentally delete configuration.nix.
  #   copySystemConfiguration = true;
  # };

  specialisation = {
    desktop.configuration = {
      services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };

      services.openssh.settings.X11Forwarding = true;
      services.openssh.extraConfig = "X11UseLocalhost no";
    };
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
  system.stateVersion = "24.05"; # Did you read the comment?

}
