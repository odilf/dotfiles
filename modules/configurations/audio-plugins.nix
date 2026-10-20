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
        inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

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

        # $HOME-relative directory where plugin hosts look for user plugins.
        formatDirs =
          if isDarwin then
            {
              LV2 = "Library/Audio/Plug-Ins/LV2";
              VST = "Library/Audio/Plug-Ins/VST";
              VST3 = "Library/Audio/Plug-Ins/VST3";
              CLAP = "Library/Audio/Plug-Ins/CLAP";
            }
          else if isLinux then
            {
              LV2 = ".lv2";
              VST = ".vst";
              VST3 = ".vst3";
              CLAP = ".clap";
            }
          else
            null;

        files = lib.concatMap (
          p:
          lib.mapAttrsToList (format: path: {
            name = "${formatDirs.${format}}/${baseNameOf path}";
            value.source = "${p.package}/${path}";
          }) p.bundles
        ) installed;

        fileEntries =
          if formatDirs == null then
            if installed == [ ] then
              { }
            else
              throw "audio-plugins: no placement mapping for ${pkgs.stdenv.hostPlatform.system} yet, but a plugin is installed in home.packages"
          else
            builtins.listToAttrs files;
      in
      {
        home.file = fileEntries;
      }
    )
  ];
}
