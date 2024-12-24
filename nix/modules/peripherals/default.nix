{ lib, config, ... }: let
	cfg = config.peripherals;
in {
	options.peripherals = {
		sidecar.enable = lib.mkEnableOption "sidecar-ssd";
	};

	config = {
	  fileSystems = {
		"/mnt/sidecar" = lib.mkIf cfg.sidecar.enable {
		  device = "/dev/disk/by-uuid/2224-14C0";
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
	};
	};
}
