{ ... }:
{
  home-manager.users."*" =
    { hmConfig, ... }:
    let
      home = hmConfig.home.homeDirectory;
      target-dir = "${home}/.cargo/.global-target";
    in
    {
      home.file.".cargo/config.toml".text = ''build.target-dir = "${target-dir}"'';
    };
}
