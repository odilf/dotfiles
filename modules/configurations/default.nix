{ lib, ... }:
let
  ignored = [
    "default.nix"
    "reaper.nix"
  ];

  entries = builtins.readDir ./.;

  modules = builtins.filter (
    name: entries.${name} == "regular" && lib.hasSuffix ".nix" name && !lib.elem name ignored
  ) (builtins.attrNames entries);
in
{
  imports = map (name: ./${name}) modules;
}
