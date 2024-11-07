# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  packages.gui = false;

  # For todoist-electron
  # TODO: Make it whitelist, don't allow all
  nixpkgs.config.allowUnfree = true;

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

  networking.hostName = "uoh-server"; # Define your hostname.

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.uoh = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  programs.mosh = {
    enable = true;
    openFirewall = true;
  };

  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "uoh" ];
        UseDns = true;
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

    jellyfin.enable = true;

    churri = {
      enable = true;
      host = "0.0.0.0";
      targetDate = "2024-11-16T15:25:00+01:00";
    };

    sentouki = {
      enable = true;
      host = "0.0.0.0";
      basePath = "/mnt/";
    };
  };

  # For immich
  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
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

    # "/mnt/UOH-MEDIA" = {
    #   device = "/dev/disk/by-uuid/89bb9652-c89b-40a5-9a76-7e64212b82f0";
    #   fsType = "btrfs";
    #   options = [ "nofail" ];
    # };

    "/mnt/INTENSO" = {
      device = "/dev/disk/by-uuid/0dfd1ee6-692f-4911-8f84-341a9aa75f4a";
      fsType = "btrfs";
      options = [ "nofail" ];
    };
  };

  # Monitoring
  services = {
    smartd = {
      enable = true;
      devices = [
        # { device = "/dev/disk/by-uuid/65B5-2A38"; } # UOH-ARCHIVE
        { device = "/dev/disk/by-uuid/2f764760-62d4-427e-b33d-b08ae3fcc5b7"; } # TOSHIBA
        { device = "/dev/disk/by-uuid/89bb9652-c89b-40a5-9a76-7e64212b82f0"; } # UOH-MEDIA
        { device = "/dev/disk/by-uuid/0dfd1ee6-692f-4911-8f84-341a9aa75f4a"; } # INTENSO
      ];
    };

    scrutiny = {
      enable = true;
      settings.web.listen.port = 8305;
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
