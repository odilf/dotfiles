{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "mac-speedrunning-tools";
  version = "3.0.0";

  src = fetchzip {
    url = "https://github.com/ducky8x/Mac-Speedrunning-Tools/releases/download/MST-v${version}/MST-${version}-macOS.zip";
    hash = "sha256-Q7xruQQeyPYMRjDng0qczpUgYOlC5KRhdLJHBM4bgNs=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "$src/MST.app" "$out/Applications/MST.app"
    chmod +x "$out/Applications/MST.app/Contents/MacOS/MST"

    runHook postInstall
  '';

  meta = {
    description = "A collection of MCSR tools (BetterNBB, WindowBackdrop, Better Piechart, MACrosshair, Key Rebinder)";
    homepage = "https://github.com/ducky8x/Mac-Speedrunning-Tools";
    platforms = lib.platforms.darwin;
  };
}
