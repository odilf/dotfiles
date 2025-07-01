{ config, lib, ... }:
{
  home-manager.users."*" =
    user:
    let
      home = config.home-manager.users."${user}".home.homeDirectory;
      target-dir = "${home}/.cargo/.global-target";
    in
    {
      home.file.".cargo/config.toml".text = ''build.target-dir = "${target-dir}"'';
    };
}
