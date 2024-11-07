{
  lib,
  ...
}:
let
  inherit (import ./util.nix lib) fill;
in
{
  options = {
	fonts.fontconfig = fill;
  };
}
