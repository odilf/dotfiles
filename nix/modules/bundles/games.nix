# TODO
# - [ ] Emulators
# - [ ] Steam
# - [ ] Terminal games

{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86;
  enable = user: config.custom.bundles."${user}".games.enable;
in
{
  users.users."*" =
    user:
    lib.mkIf (enable user) {
      packages =
        [
          # pkgs.smassh # Dependency broken on darwin
          pkgs.vitetris # Kinda mediocre
          pkgs.terminal-parrot
        ]
        ++ lib.optionals (isLinux && isx86) [
          pkgs.steam-run
          pkgs.steam-tui
        ]
        ++ lib.optionals config.gui (
          [
            pkgs.prismlauncher
            pkgs.legendary-gl
          ]
          ++ lib.optionals isLinux [
            pkgs.rare # Epic games GUI (linux)
            pkgs.dolphin-emu
            pkgs.clonehero
            pkgs.retroarch # Broken on darwin
          ]
        );
    };

  homebrew.casks = lib.optionals isDarwin [
    "epic-games"
    "minecraft"
    "steam"
    "dolphin"
    "clone-hero"
    "retroarch"
  ];
}
