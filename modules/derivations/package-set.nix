# Auto-discovered derivations in this directory.
{
  pkgs,
  lib,
  ...
}:
let
  # Files that return an *attrset* of derivations rather than a single
  # derivation. Each is exposed as a nested attrset under its file name.
  packageSets = [
    "firefox-addons.nix"
  ];

  ignored = [
    "default.nix"
    "package-set.nix"
  ];

  entries = builtins.readDir ./.;

  isDiscoverable =
    name: entries.${name} == "regular" && lib.hasSuffix ".nix" name && !lib.elem name ignored;

  discoverable = builtins.filter isDiscoverable (builtins.attrNames entries);

  singleNames = map (lib.removeSuffix ".nix") (
    builtins.filter (name: !lib.elem name packageSets) discoverable
  );
  multiNames = map (lib.removeSuffix ".nix") (
    builtins.filter (name: lib.elem name packageSets) discoverable
  );

  fromSingle = lib.genAttrs singleNames (name: pkgs.callPackage (./. + "/${name}.nix") { });

  fromMulti = lib.genAttrs multiNames (name: pkgs.callPackages (./. + "/${name}.nix") { });
in
fromSingle // fromMulti
