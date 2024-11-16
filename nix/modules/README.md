Modules for my nix configurations. 

The structure is the following:

- [`packages`](./packages): Packages and packages bundles. It has options to specify whether a GUI is used or not, and a few general bundles which is usually what you want to use. There is also [`packages/configured`](./packages/configured), which is kind of like `programs.foobar` except that they're configured to my liking. These are the ones used in the bundles, but theoretically could be used standalone or without the configuration. If it needs to set up home for a specific user, you can specify the users in `packages.users` or, if left blank, it automatically does it for each user defined in `users.users`. 

- [`desktop-environment`](./desktop-environment): Configuration for having a usable desktop environment. This sets up hyprland on NixOS or just sets up various finder, dock, etc. options on macOS. 

- [`polyfill`](./polyfill): Polyfills to be able to declare options on nix-darwin that don't exist in NixOS or viceversa. In other words, `homebrew` is not a valid option on NixOS so if you have a configuration that uses it it will throw an error and refuse to build, even if you have a `lib.mkIf isDarwin` guard. This happens the other way around with `fonts.defaultFonts` that exists in NixOS but not in nix-darwin. The polyfill declares the options to allow to build. It will throw while building if the options are used improperly (i.e., if NixOS ends up using `homebrew`). 
