# AGENTS.md

Nix flake (flake-parts) dotfiles for four hosts: `macbook` (aarch64-darwin),
`nixbook` (aarch64-linux), `ada` (x86_64-linux, WSL), `vermeer` (nix-on-droid).
Also exports `nixosModules.default` / `darwinModules.default` for reuse in other flakes.

## Commands

- Do `jj st` when adding files to track them.
- Format (nixfmt, in place): `nix fmt`
- Verify everything evaluates (`nixosConfigurations`, `darwinConfigurations`, packages): `nix flake check`
- Build one custom package: `nix build .#<name>`
- NEVER apply host configs.

## Layout — the non-obvious parts

- `modules/configurations/*.nix` are ordinary NixOS modules, one per program or
  concern, mostly contributing `home-manager.sharedModules`. Every `.nix` file in the
  directory is auto-imported; `default.nix` and `reaper.nix` are the only exclusions.
- Per-user config is driven by `custom.bundles.<user>.<bundle>.enable` (options in
  `modules/bundles/default.nix`). Bundles expand over `config.custom.bundles` with
  `home-manager.users = lib.mapAttrs (user: _: lib.mkIf (enabled user) { ... }) ...`,
  so a user only gets a bundle's packages when they opt in.
- `modules/bundles/desktop-environment.nix` is the always-on GUI layer: it applies to
  every host with `gui = true` and splits the rest on `isLinux` / `isDarwin`.
- `modules/derivations/`: every `foo.nix` is auto-discovered by `package-set.nix` and
  exposed as package `.#foo` (via callPackage); no registration needed. A file that
  returns an attrset of derivations must be listed in that file's `packageSets`.
- `modules/polyfill/`: declares platform-specific options (e.g. `homebrew` on NixOS)
  so one config evaluates on every platform; actually using the wrong one fails the
  build.
- `modules/staging/home-manager/`: real home-manager modules for programs without
  an upstream module (`karabiner`, `linkLive`, `mcsr`, `theme-switch`).
- Host configs (`hosts/<name>/configuration.nix`) set `gui`, per-user bundles under
  `custom.bundles.<user>`, host-specific options (e.g. `laptop.enable`), and
  `custom.flake-path`. Without `custom.flake-path = "<repo path>#<hostname>"` the
  live-files mechanism silently no-ops and `nh` has no flake.

## `live/` files

Stateful/undocumented app configs are symlinked from the repo into `$HOME` via
`home.linkLive.files = { "<$HOME-relative target>" = "<repo-relative source>"; }`
(option in `modules/staging/home-manager/link-live.nix`). Apps mutate these files
at runtime, so `live/` showing up dirty in git is normal — commit the changes.
Prefer linking directories, not files.

## Secrets

agenix: encrypted files in `secrets/*.age`, recipient keys declared in
`secrets/secrets.nix`. On darwin, home-manager agenix uses `/tmp/agenix`
(see `modules/configurations/home-manager.nix`).
