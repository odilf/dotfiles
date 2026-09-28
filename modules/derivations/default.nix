{ ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      import ./package-set.nix {
        lib = prev.lib;
        pkgs = final;
      }
    )
  ];
}
