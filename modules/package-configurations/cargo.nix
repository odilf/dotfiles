{
  pkgs,
  config,
  lib,
  ...
}:
let
  utils = import ../utils.nix { inherit config lib pkgs; };
in
{
  home-manager.users."*" =
    { hmConfig, user, ... }:
    let
      home = hmConfig.home.homeDirectory;
      target-dir = "${home}/.cargo/.global-target";
    in
    {
      home.file.".cargo/config.toml" = lib.mkIf (utils.packageInstalled pkgs.cargo user) {
        text = ''build.target-dir = "${target-dir}"'';
      };
    };
}
