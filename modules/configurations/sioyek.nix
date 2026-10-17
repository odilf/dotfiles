{ pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  # Sioyek has the -1 app id problem
  pkg =
    if isDarwin then
      pkgs.sioyek.overrideAttrs (_: {
        # https://github.com/NixOS/nixpkgs/pull/566097/changes
        postInstall = ''
          mkdir -p sioyek.app/Contents/Resources
          cp -r pdf_viewer/shaders sioyek.app/Contents/Resources/shaders
          cp pdf_viewer/{prefs,prefs_user,keys,keys_user}.config tutorial.pdf sioyek.app/Contents/Resources/

          mkdir -p $out/Applications
          cp -r sioyek.app $out/Applications
        '';

        # https://github.com/NixOS/nixpkgs/issues/571894
        # CFBundleExecutable must be the Qt binary itself: an executable that
        # execs a differently named binary leaves macOS with a stale (pid = -1)
        # app record that AeroSpace cannot manage. The plugins are supplied
        # through the bundle environment instead.
        postFixup = ''
          app="$out/Applications/sioyek.app"
          mv "$app/Contents/MacOS/.sioyek-wrapped" "$app/Contents/MacOS/sioyek"

          qtPluginPath=""
          for ((i = 0; i < ''${#qtWrapperArgs[@]}; i++)); do
            if [ "''${qtWrapperArgs[i]}" = "--prefix" ] && [ "''${qtWrapperArgs[i + 1]}" = "QT_PLUGIN_PATH" ]; then
              qtPluginPath="$qtPluginPath''${qtPluginPath:+:}''${qtWrapperArgs[i + 3]}"
              i=$((i + 3))
            fi
          done

          /usr/bin/plutil -remove LSEnvironment "$app/Contents/Info.plist" 2>/dev/null || true
          /usr/bin/plutil -insert LSEnvironment \
            -json "{\"QT_PLUGIN_PATH\":\"$qtPluginPath\"}" \
            "$app/Contents/Info.plist"

          mkdir -p $out/bin
          echo "#!${pkgs.runtimeShell}" > $out/bin/sioyek
          echo "export QT_PLUGIN_PATH=\"$qtPluginPath\"" >> $out/bin/sioyek
          echo "exec \"$app/Contents/MacOS/sioyek\" \"\$@\"" >> $out/bin/sioyek
          chmod +x $out/bin/sioyek
        '';
      })
    else
      pkgs.sioyek;
in
{
  home-manager.sharedModules = [
    {
      programs.sioyek.package = pkg;
      programs.sioyek.config = {
        ui_font = "IosevkaTerm Nerd Font";
        default_dark_mode = "1";
        should_launch_new_window = "1";
        should_draw_unrendered_pages = "1";
        inverse_search_command = "$EDITOR %1:%2";

        create_table_of_contents_if_not_exists = "1";
        max_created_toc_size = "5000";
        super_fast_search = "1";

        # https://github.com/ahrm/sioyek/issues/1488
        # Available since Oct 17, 2025, but sioyek has no releases since Dec 16, 2022 :(
        # but nixpkgs packages an unstable version! I <3 nix ^^
        open_last_file_on_startup = "1";
      };

    }
  ];
}
