{ ... }:
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
        home = config.home.homeDirectory;
        target-dir = "${home}/.cargo/.global-target";
      in
      {
        home.file.".cargo/config.toml" = lib.mkIf (builtins.elem pkgs.cargo config.home.packages) {
          text = ''build.target-dir = "${target-dir}"'';
        };
      }
    )
  ];
}
