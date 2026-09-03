{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      osx-scrobbler = final.callPackage (import ./osx-scrobbler.nix) { };
      noctavox = final.callPackage (import ./noctavox.nix) { };
    })
  ];
}
