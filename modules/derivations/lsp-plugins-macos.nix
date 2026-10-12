{
  lib,
  pkgs,
}:
if !pkgs.stdenv.hostPlatform.isDarwin then
  pkgs.lsp-plugins
else
  pkgs.lsp-plugins.overrideAttrs (old: {
    buildInputs = [
      pkgs.cairo
      pkgs.freetype
      pkgs.fontconfig
      pkgs.libiconv
    ];

    # macOS install roots are absolute and ignore PREFIX; pin them into $out.
    makeFlags = old.makeFlags ++ [
      "LIBDIR=${placeholder "out"}/lib"
      "MACOS_PLUGIN_LIBDIR=${placeholder "out"}/lib"
    ];

    # The sandbox has no codesign; the linker already ad-hoc signs Mach-O.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace modules/lsp-plugin-fw/src/Makefile \
        --replace-fail 'codesign --force --deep --sign -' 'true'
    '';

    meta = old.meta // {
      platforms = lib.platforms.darwin;
    };
  })
