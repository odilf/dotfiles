# Modules

Modules for my nix configurations.

The structure is the following:

- [`configurations`](./configurations): One module per program or concern, kind of
  like `programs.foobar` except configured to my liking. These are the modules the
  bundles use, but theoretically could be imported standalone. If a configuration
  needs to set up home for a specific user, it contributes
  `home-manager.sharedModules` and gates its options on the user's own config. Every
  `.nix` file in the directory is imported automatically (`reaper.nix` is skipped).

- [`bundles`](./bundles): Opinionated groups of software (`development`, `creative`,
  `games`, `productivity`, `social`). A host opts in per user with
  `custom.bundles.<user>.<bundle>.enable`, and each bundle expands that into the
  user's home-manager config. [`bundles/desktop-environment.nix`](./bundles/desktop-environment.nix)
  is separate: it's the always-on GUI layer, applied to every host with `gui = true`,
  and it splits the rest of its contents on `isLinux`/`isDarwin`.

- [`derivations`](./derivations): Custom packages. Every `foo.nix` is auto-discovered
  by [`package-set.nix`](./derivations/package-set.nix) and exposed as `.#foo`. A file
  that returns an attrset of derivations has to be listed in that file's `packageSets`.

- [`services`](./services): System services, currently the Immich album downloader.

- [`polyfill`](./polyfill): Polyfills to be able to declare options on nix-darwin that
  don't exist in NixOS or viceversa. In other words, `homebrew` is not a valid option
  on NixOS so if you have a configuration that uses it it will throw an error and
  refuse to build, even if you have a `lib.mkIf isDarwin` guard. This happens the other
  way around with `system.defaults`, which exists in nix-darwin but not in NixOS. The
  polyfill declares the foreign options with `fill` (in [`util.nix`](./polyfill/util.nix)),
  so the configuration evaluates and only throws while building if the options are
  actually used (i.e., if NixOS ends up using `homebrew`). Each platform file is
  imported per machine type; see [`polyfill/README.md`](./polyfill/README.md).

- [`staging`](./staging): Home-manager modules for programs that don't have an upstream
  module yet (`karabiner`, `linkLive`, `mcsr`, `theme-switch`), and therefore candidates
  for upstreaming.
