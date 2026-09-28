{
  lib,
  stdenv,
  runtimeShell,
  fetchFromGitHub,
}:

let
  # Upstream publishes no build system (CMakeLists.txt / build.sh are
  # git-ignored and were never committed), so this derivation reconstructs the
  # build from the include graph and links the DYLD-injected overlay library
  # directly with clang.
  imgui = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "bf75bfec48fc00f532af8926130b70c0e26eb099"; # v1.92.3
    hash = "sha256-J+h7jJ+4wqr6RivtzyTDMXKxFoGs7dQbzqdu51XgEbc=";
  };

  imGuiFileDialog = fetchFromGitHub {
    owner = "aiekick";
    repo = "ImGuiFileDialog";
    rev = "d0e97b2adc3d3452d72c750c7305dc0291acd052";
    hash = "sha256-Izl4YcMRYDfXRQot7H1o2yGANl6bZUpO+rrxARQyu6w=";
  };

  imAnim = fetchFromGitHub {
    owner = "soufianekhiat";
    repo = "ImAnim";
    rev = "1ea19a55a28d54acb7f7f22a617f969aec2a073e";
    hash = "sha256-62jZGxEueGmbLKhrT5zGLaf2LN5nl7t0Fo+lr/e/RW0=";
  };

  tomlplusplus = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    rev = "30172438cee64926dc41fdd9c11fb3ba5b2ba9de"; # v3.4.0
    hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
  };

  stb = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "2c980bb59875b0d32144a71867fbdebb2f77cd20";
    hash = "sha256-vA5RZLte4gf5/NkbWT3VNzGVD04kyVTHPeEZwxNnxi0=";
  };

  # Translation units that are not #included by any other .cpp (derived from
  # the include graph). Linux-only units compile to nothing on Darwin.
  rootSources = [
    "platform/common/anchor_coords.cpp"
    "platform/common/config/io_detail.cpp"
    "platform/common/config/toml_detail.cpp"
    "platform/common/config_editor_helpers.cpp"
    "platform/common/config_io.cpp"
    "platform/common/config_toml.cpp"
    "platform/common/font_scanner.cpp"
    "platform/common/game_state_monitor.cpp"
    "platform/common/input/glfw_vk_mapper.cpp"
    "platform/common/input/hotkey_capture_state.cpp"
    "platform/common/input/hotkey_dispatcher.cpp"
    "platform/common/input/hotkey_matcher.cpp"
    "platform/common/input/key_state_tracker.cpp"
    "platform/common/platform_runtime.cpp"
    "platform/x11/glx_mirror_pipeline.cpp"
    "platform/x11/macos_clipboard.mm"
    "platform/x11/mirror/glx_shared_contexts.cpp"
    "platform/x11/mirror/mirror_image_source.cpp"
    "platform/x11/mirror/mirror_mode_state.cpp"
    "platform/x11/overlay/gui/imgui_overlay_helpers.cpp"
    "platform/x11/overlay/gui/tab_eyezoom.cpp"
    "platform/x11/overlay/gui/tab_inputs.cpp"
    "platform/x11/overlay/gui/tab_mirrors.cpp"
    "platform/x11/overlay/gui/tab_misc.cpp"
    "platform/x11/overlay/gui/tab_modes.cpp"
    "platform/x11/overlay/imgui_input_bridge.cpp"
    "platform/x11/overlay/imgui_overlay.cpp"
    "platform/x11/preload_glx_swap_interposer.cpp"
    "platform/x11/window_capture.cpp"
    "platform/x11/window_capture.mm"
    "platform/x11/window_capture_linux.cpp"
    "platform/x11/window_capture_wayland.cpp"
    "platform/x11/window_capture_x11.cpp"
    "platform/x11/x11_clipboard.cpp"
    "platform/x11/x11_runtime.cpp"
  ];

  dependencySources = [
    "${imgui}/imgui.cpp"
    "${imgui}/imgui_draw.cpp"
    "${imgui}/imgui_tables.cpp"
    "${imgui}/imgui_widgets.cpp"
    "${imgui}/backends/imgui_impl_opengl3.cpp"
    "${imGuiFileDialog}/ImGuiFileDialog.cpp"
    "${imAnim}/im_anim.cpp"
  ];
in
stdenv.mkDerivation {
  pname = "linuxscreen";
  version = "unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "isqqcle";
    repo = "Linuxscreen";
    rev = "4535fb9131f0fee44bcf7f9852f9eff672ab5728";
    hash = "sha256-8+vRip32DKSJDucemQb0fwtIxWvS2CqGMzJNv8ab9WQ=";
  };

  postPatch = ''
    mkdir -p deps
    cp -R ${imgui} deps/imgui
    cp -R ${imGuiFileDialog} deps/ImGuiFileDialog
    cp -R ${imAnim} deps/ImAnim
    cp -R ${tomlplusplus} deps/tomlplusplus
    cp -R ${stb} deps/stb
    chmod -R u+w deps
    patch -d deps/imgui -p1 < ${./linuxscreen/imgui-rightclick-input.patch}
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p out/obj

    includes="-Isrc -Isrc/platform -Isrc/platform/common -Isrc/platform/common/config -Isrc/platform/common/input -Isrc/platform/x11 -Isrc/platform/x11/mirror -Isrc/platform/x11/overlay -Isrc/platform/x11/overlay/gui -Isrc/platform/x11/hook -Ideps/imgui -Ideps/imgui/backends -Ideps/ImGuiFileDialog -Ideps/ImAnim -Ideps/tomlplusplus/include/toml++ -Ideps/stb"

    flags="-std=c++17 -O2 -fno-objc-arc -DGL_SILENCE_DEPRECATION -Wno-unknown-pragmas"

    for f in ${lib.concatStringsSep " " rootSources}; do
      obj="out/obj/$(echo "$f" | tr '/' '_').o"
      echo "CXX src/$f"
      clang++ $flags $includes -c "src/$f" -o "$obj"
    done

    for f in ${lib.concatStringsSep " " dependencySources}; do
      obj="out/obj/$(echo "$f" | tr '/' '_').o"
      echo "CXX $f"
      clang++ $flags $includes -c "$f" -o "$obj"
    done

    clang++ -dynamiclib -o out/liblinuxscreen.dylib \
      out/obj/*.o \
      -install_name @rpath/liblinuxscreen.dylib \
      -framework OpenGL \
      -framework AppKit \
      -framework Foundation \
      -framework CoreFoundation \
      -framework CoreGraphics \
      -framework CoreMedia \
      -framework CoreVideo \
      -framework ScreenCaptureKit

    runHook postBuild
  '';

  installPhase = ''
        runHook preInstall
        mkdir -p $out/lib $out/bin
        cp out/liblinuxscreen.dylib $out/lib/liblinuxscreen.dylib

        # Wrapper for launchers (PrismLauncher / MCSR Launcher "wrapper command"):
        # it receives the java invocation as "$@" and injects the overlay dylib
        # into the JVM via dyld.
        cat > $out/bin/linuxscreen-wrapper <<EOF
    #!${runtimeShell}
    if [ -n "\$DYLD_INSERT_LIBRARIES" ]; then
      export DYLD_INSERT_LIBRARIES="$out/lib/liblinuxscreen.dylib:\$DYLD_INSERT_LIBRARIES"
    else
      export DYLD_INSERT_LIBRARIES="$out/lib/liblinuxscreen.dylib"
    fi
    exec "\$@"
    EOF
        chmod +x $out/bin/linuxscreen-wrapper

        runHook postInstall
  '';

  meta = {
    description = "Minecraft screen mirroring and overlay tool injected into the game via DYLD";
    homepage = "https://github.com/isqqcle/Linuxscreen";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
