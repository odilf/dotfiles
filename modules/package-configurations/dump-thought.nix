{ pkgs, ... }:

let
  dump = pkgs.writeShellScriptBin "dump" ''
    exec ${pkgs.python3}/bin/python3 ${./dump-thought.py} "$@"
  '';
in
{
  home-manager.users."*" = {
    home.packages = [ dump ];
  };
}
