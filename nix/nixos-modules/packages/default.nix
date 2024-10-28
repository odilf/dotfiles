{ pkgs, lib, ... }:
{
  imports = [
    ./games.nix
    ./development.nix
  ];

  development-packages.enable = lib.mkDefault true;
}
