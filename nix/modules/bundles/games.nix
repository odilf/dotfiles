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
      packages = [
        # pkgs.smassh # Dependency broken on darwin
        pkgs.vitetris # Kinda mediocre
        pkgs.terminal-parrot
      ]
      ++ lib.optionals (isLinux && isx86) [
        pkgs.steam-run
        pkgs.steam-tui
        pkgs.clonehero
      ]
      ++ lib.optionals config.gui (
        [
          pkgs.legendary-gl
        ]
        ++ lib.optionals isLinux [
          # TODO: Move back to darwin when qtbase6 is fixed
          pkgs.prismlauncher
          pkgs.rare # Epic games GUI (linux)
          pkgs.dolphin-emu
          pkgs.retroarch # Broken on darwin
        ]
      );
    };

  homebrew.casks = lib.optionals isDarwin [
    # TODO: Apparently it doesn't work in packages?? :(
    "prismlauncher"
    "epic-games"
    "minecraft"
    "steam"
    "dolphin"
    "clone-hero"
    "retroarch-metal"
  ];
}
