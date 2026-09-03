{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "osx-scrobbler";
  version = "unstable-2026-08-02";

  src = fetchFromGitHub {
    owner = "theli-ua";
    repo = "osx-scrobbler";
    rev = "0e1e653";
    hash = "sha256-L4BpfN5TcSWBIKAKHq0g3JZje9wfkUQQXCqz9SZ4FBs=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";
  meta = with lib; {
    description = "Menu bar scrobbler for last.fm and ListenBrainz on macOS";
    homepage = "https://github.com/theli-ua/osx-scrobbler";
    license = licenses.asl20;
    platforms = platforms.darwin;
  };
}
