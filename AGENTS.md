# AGENTS.md

Nix flake (flake-parts) dotfiles for four hosts: `macbook` (aarch64-darwin),
`nixbook` (aarch64-linux), `ada` (x86_64-linux, WSL), `vermeer` (nix-on-droid).
Also exports `nixosModules.default` / `darwinModules.default` for reuse in other flakes.

## Commands

- Format (nixfmt, in place): `nix fmt`
- Verify everything evaluates (`nixosConfigurations`, `darwinConfigurations`, packages): `nix flake check`
- Build one custom package: `nix build .#<name>`
- NEVER apply host configs.

## Layout — the non-obvious parts

- `modules/package-configurations/*.nix` are **not** plain NixOS modules: plain attrsets,
  wired up by the import list in `modules/package-configurations/default.nix` and the
  merge machinery in `modules/utils.nix`. A new file must be added to that import
  list. Top-level attrs outside `knownAttrs` (in `default.nix`) only produce build
  *warnings* — a typo'd attr does not fail the build.
- Per-user config uses the `"*"` wildcard: `home-manager.users."*"` (and
  `users.users."*"`) may be a function `{ user, hmConfig, enableBundle } -> config`,
  expanded once per user declared in `custom.bundles.<user>.*`.
- `modules/derivations/`: every `foo.nix` is auto-discovered and exposed as package
  `.#foo` (via callPackage); no registration needed.
- `modules/polyfill/`: declares platform-specific options (e.g. `homebrew` on NixOS)
  so one config evaluates on every platform; actually using the wrong one fails the
  build.
- `modules/staging/home-manager/`: real home-manager modules for programs without
  an upstream module (`linkLive`, `mcsr`, `karabiner`).
- Host configs (`hosts/<name>/configuration.nix`) set `gui`,
  `desktop-environment` (string: `"niri"`, `"macOS"`, ...), per-user bundles, and
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
(see `modules/package-configurations/home-manager.nix`).
