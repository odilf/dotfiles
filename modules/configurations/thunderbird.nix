{ pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  # Essentially the same problem with sioyek.
  # https://github.com/NixOS/nixpkgs/issues/571894
  pkg =
    if isDarwin then
      pkgs.thunderbird.overrideAttrs (old: {
        buildCommand = old.buildCommand + ''
          app="$out/Applications/Thunderbird.app"
          macos="$app/Contents/MacOS"
          plist="$app/Contents/Info.plist"

          # The wrappers compute their environment at run time; run them against
          # a stub that prints it instead of starting the browser.
          stub="$(mktemp -d)"
          printf '#!/bin/sh\nenv\n' > "$stub/env"
          chmod +x "$stub/env"
          mv "$macos/.thunderbird-old" "$macos/.thunderbird-real"
          ln -s "$stub/env" "$macos/.thunderbird-old"
          wrapper_env="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin "$macos/thunderbird")"
          rm -f "$macos/.thunderbird-old" "$stub/env"
          rmdir "$stub"

          # Info.plist is a symlink into the unwrapped derivation.
          if [ -L "$plist" ]; then
            plistSrc="$(readlink -f "$plist")"
            rm "$plist"
            install -m 644 "$plistSrc" "$plist"
          fi

          envPlist="$(mktemp)"
          /usr/bin/plutil -create xml1 "$envPlist"
          while IFS= read -r line; do
            key="''${line%%=*}"
            case "$key" in
              PWD|OLDPWD|SHLVL|_) continue ;;
            esac
            /usr/bin/plutil -insert "$key" -string "''${line#*=}" "$envPlist"
          done <<< "$wrapper_env"
          /usr/bin/plutil -remove LSEnvironment "$plist" 2>/dev/null || true
          /usr/bin/plutil -insert LSEnvironment \
            -json "$(/usr/bin/plutil -convert json -o - "$envPlist")" "$plist"
          rm "$envPlist"

          # The declared executable has to be the real binary itself.
          rm "$macos/thunderbird" "$macos/.thunderbird-wrapped"
          mv "$macos/.thunderbird-real" "$macos/thunderbird"

          # Command-line entry point, carrying the same environment.
          mkdir -p "$out/bin"
          {
            printf '#!%s\n' "${pkgs.runtimeShell}"
            while IFS= read -r line; do
              key="''${line%%=*}"
              case "$key" in
                PWD|OLDPWD|SHLVL|_) continue ;;
              esac
              builtin printf 'export %s=%q\n' "$key" "''${line#*=}"
            done <<< "$wrapper_env"
            printf 'exec %s "$@"\n' "$macos/thunderbird"
          } > "$out/bin/thunderbird"
          chmod +x "$out/bin/thunderbird"
        '';
      })
    else
      pkgs.thunderbird;
in
{
  home-manager.sharedModules = [
    {
      programs.thunderbird.package = pkg;
    }
  ];
}
