# Dotfiles

My dotfiles, configured with nix.

The entrypoint for the configurations is the nix flake, that just has
- NixOS system configuration output for each linux host
- nix-darwin system configuration output for each MacOS host.
- A NixOS module and a nix-darwin module output for using the dotfiles in other flakes.

Some programs don't expect manual configuration and just have a big config file with a bunch of info and often no documentation. For those programs we just symlink the relevant directory (say, `~/.config/<name>`) to the files in `./live`.

In other words, those config files are "live" (omg naming). The idea is that if the application changes these files, they show up as dirty in git and can be easily committed. This results in at least a consistent config, if less intentional.

The other usecase of live files is (even for standard text-based config with nice docs) that if the application has live reloading then it can do the reloading, live. For instance, niri.
