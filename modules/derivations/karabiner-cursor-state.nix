{
  lib,
  rustPlatform,
}:
let
  src = ./karabiner-cursor-state;
in
rustPlatform.buildRustPackage {
  pname = "karabiner-cursor-state";
  version = "0.1.0";

  inherit src;
  cargoLock.lockFile = "${src}/Cargo.lock";

  meta = {
    description = "Mirror macOS cursor visibility into a Karabiner-Elements variable so key rebinds can be gated on the mouse being captured";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
