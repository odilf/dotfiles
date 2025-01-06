{ lib, pkgs, config, ... }: let 
  utils = import ../utils.nix { inherit lib pkgs config; };
	in {
	config = utils.eachHome {
		services.syncthing = {
			enable = true;
		};
	};
}
