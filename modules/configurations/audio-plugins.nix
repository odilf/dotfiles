{
  ...
}:
{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (pkgs.stdenv.hostPlatform) isDarwin;

        # `bundles` maps the host format directory to the bundle's path inside
        # the package.
        plugins = [
          {
            package = pkgs.lsp-plugins-macos;
            bundles = {
              LV2 = "lib/LV2/lsp-plugins.lv2";
              VST = "lib/VST/lsp-plugins.vst";
              VST3 = "lib/VST3/lsp-plugins.vst3";
              CLAP = "lib/CLAP/lsp-plugins.clap";
            };
          }
        ];

        installed = builtins.filter (p: builtins.elem p.package config.home.packages) plugins;

        files = lib.concatMap (
          p:
          lib.mapAttrsToList (format: path: {
            name = "Library/Audio/Plug-Ins/${format}/${baseNameOf path}";
            value.source = "${p.package}/${path}";
          }) p.bundles
        ) installed;

        fileEntries =
          if isDarwin then
            builtins.listToAttrs files
          else if installed == [ ] then
            { }
          else
            throw "audio-plugins: no placement mapping for ${pkgs.stdenv.hostPlatform.system} yet, but a plugin is installed in home.packages";
      in
      {
        home.file = fileEntries;
      }
    )
  ];
}
