{
  pkgs,
  lib,
  ...
}:
let
  ignored = [
    "default.nix"
  ];
  files = builtins.attrNames (removeAttrs (builtins.readDir ./.) ignored);

  modules = builtins.filter (lib.strings.hasSuffix ".nix") files;
  names = map (lib.strings.removeSuffix ".nix") modules;

  multisets = [ "firefox-addons" ];
in
lib.genAttrs names (
  name:
  if lib.elem name multisets then
    pkgs.callPackages ./${name}.nix { }
  else
    pkgs.callPackage ./${name}.nix { }
)
