# Auto-discovered derivations in this directory.
{
  pkgs,
  lib,
  ...
}:
let
  excluded = [
    "default.nix"
    "package-set.nix"
    "firefox-addons.nix"
  ];

  entries = builtins.readDir ./.;

  isPackage =
    name: entries.${name} == "regular" && lib.hasSuffix ".nix" name && !lib.elem name excluded;

  names = map (lib.removeSuffix ".nix") (builtins.filter isPackage (builtins.attrNames entries));
in
lib.genAttrs names (name: pkgs.callPackage (./. + "/${name}.nix") { })
