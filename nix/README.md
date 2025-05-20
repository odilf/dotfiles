Nix configurations

The entrypoint for the configurations is the nix flake, that just has
- NixOS system configuration output for each linux host
- nix-darwin system configuration output for each MacOS host.
- A NixOS module and a nix-darwin module output for using the dotfiles in other flakes.

