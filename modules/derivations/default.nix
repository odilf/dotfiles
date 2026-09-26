{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      osx-scrobbler = final.callPackage (import ./osx-scrobbler.nix) { };
      noctavox = final.callPackage (import ./noctavox.nix) { };
      ninjabrain-bot-app = final.callPackage (import ./ninjabrain-bot-app.nix) { };
      mac-speedrunning-tools = final.callPackage (import ./mac-speedrunning-tools.nix) { };
      karabiner-cursor-state = final.callPackage (import ./karabiner-cursor-state.nix) { };
    })
  ];
}
