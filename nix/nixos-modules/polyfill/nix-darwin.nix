{
  lib,
  ...
}:
let
	inherit (import ./util.nix lib) fill;
in {
  options = {
	homebrew = fill;
	security = {
		pam.enableSudoTouchIdAuth = fill;
	};

	services = {
			aerospace = fill;
	};

	system.defaults = fill;
  };
}
