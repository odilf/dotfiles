{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
rustPlatform.buildRustPackage rec {
  pname = "NoctaVox";
  version = "unstable-2026-08-02";

  src = fetchFromGitHub {
    owner = "Jaxx497";
    repo = "NoctaVox";
    rev = "44225e4";
    hash = "sha256-dDhxQUvDwN8wS2nzruMggw+gSjje+NGy3fvmR8y06C0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cargoLock.lockFile = "${src}/Cargo.lock";
  meta = with lib; {
    description = "Local TUI Music Player";
    homepage = "https://github.com/Jaxx497/NoctaVox";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
