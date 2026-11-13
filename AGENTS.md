# AGENTS.md

Nix flake (flake-parts) dotfiles. Hosts: `macbook` (aarch64-darwin), `nixbook`
(aarch64-linux, Asahi), `ada` (x86_64-linux, WSL). Also exports
`nixosModules.default` / `darwinModules.default` for reuse in other flakes
(flake.nix wires `./modules` + the per-platform polyfill + home-manager + agenix).

## Commands

- `jj st` when adding files, so they get tracked.
- `nix fmt` — nixfmt, in place.
- `nix flake check` — verifies `nixosConfigurations`, `darwinConfigurations` and `packages` evaluate.
- `nix build .#<name>` — build one custom package.
- NEVER apply host configs.

## Layout

- `hosts/<name>/configuration.nix` is the per-host entrypoint. Per-user config is
  set directly there under `home-manager.users.<user>` — there are no bundles.
  GUI hosts additionally import `../desktop-environment.nix`, the shared GUI
  layer, which splits on `isLinux`/`isDarwin` (macbook and nixbook import it;
  ada doesn't). `custom.flake-path = "<repo path>#<host>"` matters beyond `nh`:
  without it `linkLive` links nothing (see below). `custom.laptop` is a plain
  bool (`custom.laptop = true` on nixbook).
- `modules/configurations/`: every `*.nix` file is auto-imported except
  `default.nix`. Subdirectories (`ai/`, `helix/`, `librewolf/`, `zellij/`) are
  not auto-imported — their sibling module references them. Modules contribute
  `home-manager.sharedModules`.
- `modules/services/`: system services (currently the Immich album downloader).
- `modules/derivations/`: every `foo.nix` is auto-discovered by `default.nix` and
  exposed as `.#foo`. A file returning an attrset of derivations must be listed
  in that file's `multisets` (called via `callPackages`); `flake.nix` flattens
  `firefox-addons`/`helix-plugins` into `packages` so `nix flake check` and
  nix-update see flat attrs, while modules reach the nested form through the
  overlay in `modules/default.nix` (`pkgs.firefox-addons.<name>`).
  `legacyPackages` keeps the unflattened set.
- `modules/polyfill/`: one file per platform (`nixos.nix`, `nix-darwin.nix`, …),
  imported per host type in `flake.nix`. They declare the foreign options with
  `fill` (`util.nix`) so one config evaluates on every platform; the build fails
  only if the wrong platform actually uses them. `nix-on-droid.nix` is currently
  unused — no nix-on-droid host anymore.
- `modules/staging/home-manager/`: home-manager modules with no upstream module
  (`karabiner`, `link-live`, `mcsr`, `theme-switch`). Imported into every home
  config by `modules/configurations/home-manager.nix`, which also wires the
  home-manager agenix module (`passthru.agenix-hm`).
- `modules/default.nix`: declares `gui` and `custom.flake-path`, imports
  `configurations` + `services`, applies the derivations overlay, and sets
  `allowUnfreePredicate` (reaper, clonehero, ouch). No host sets `gui` today, so
  the `config.gui` guard in `macos.nix` is currently inert.

## `live/` files

`home.linkLive.files` (`modules/staging/home-manager/link-live.nix`) maps a
`$HOME`-relative target to a repo-relative source. `home-manager.nix` sets
`linkLive.repoPath` from `custom.flake-path` (the part before `#`); when that is
null nothing is linked, so importing this flake from elsewhere doesn't break.
Links are out-of-store symlinks, so apps mutate the repo files in place: a dirty
`live/` is expected — commit it. Prefer linking directories over files (currently
`.config/niri` and `.config/MusicBrainz`; `live/.gitignore` covers swap/tmp
files).

## Secrets

Encrypted files in `secrets/*.age`; recipient keys per machine in
`secrets/agenix-rules.nix` (agenix rekey-rules format). Consumers declare
`age.secrets.<name>.file = ../../secrets/<name>.age` inside home-manager modules.
On darwin the home-manager agenix module uses `secretsMountPoint = /tmp/agenix.d`
and `secretsDir = /tmp/agenix` (`modules/configurations/home-manager.nix`).
