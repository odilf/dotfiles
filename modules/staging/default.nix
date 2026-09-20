{ ... }:
{
  # Modules for programs that don't have a stock NixOS/Home Manager module yet.
  # Candidates for upstreaming.
  imports = [
    ./karabiner-module.nix
    ./mcsr-module.nix
  ];
}
