{ lib, ... }:
let
  ignored = [
    "default.nix"
  ];

  files = builtins.attrNames (removeAttrs (builtins.readDir ./.) ignored);
  modules = builtins.filter (lib.strings.hasSuffix ".nix") files;
in
{
  imports = map (module: ./${module}) modules;
}
