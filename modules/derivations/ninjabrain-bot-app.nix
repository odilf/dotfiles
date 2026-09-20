{
  lib,
  stdenvNoCC,
  ninjabrain-bot,
  runtimeShell,
}:
stdenvNoCC.mkDerivation {
  pname = "ninjabrain-bot-app";
  version = ninjabrain-bot.version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    app="$out/Applications/NinjabrainBot.app"
    mkdir -p "$app/Contents/MacOS"

    cat > "$app/Contents/Info.plist" <<PLIST
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleExecutable</key>
      <string>NinjabrainBot</string>
      <key>CFBundleIdentifier</key>
      <string>com.local.ninjabrainbot</string>
      <key>CFBundleName</key>
      <string>NinjabrainBot</string>
      <key>CFBundleDisplayName</key>
      <string>Ninjabrain Bot</string>
      <key>CFBundlePackageType</key>
      <string>APPL</string>
      <key>CFBundleShortVersionString</key>
      <string>${ninjabrain-bot.version}</string>
      <key>CFBundleVersion</key>
      <string>${ninjabrain-bot.version}</string>
      <key>LSMinimumSystemVersion</key>
      <string>10.13</string>
      <key>NSHighResolutionCapable</key>
      <true/>
    </dict>
    </plist>
    PLIST

    cat > "$app/Contents/MacOS/NinjabrainBot" <<EOF
    #!${runtimeShell}
    exec "${ninjabrain-bot}/bin/ninjabrain-bot" "\$@"
    EOF
    chmod +x "$app/Contents/MacOS/NinjabrainBot"

    runHook postInstall
  '';

  meta = {
    description = "Ninjabrain Bot stronghold calculator packaged as a launchable macOS application";
    homepage = "https://github.com/Ninjabrain1/Ninjabrain-Bot";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.darwin;
  };
}
