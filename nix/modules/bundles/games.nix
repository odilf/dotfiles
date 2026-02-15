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
in
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "clonehero"
    ];

  boot.binfmt.emulatedSystems = lib.mkIf (!isx86) [ "x86_64-linux" ];

  users.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "games") {
      packages = [
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
          pkgs.legendary-gl
        ]
        ++ lib.optionals isLinux [
          # TODO: Move back to darwin when qtbase6 is fixed
          pkgs.prismlauncher
          # pkgs.clonehero
          pkgs.pkgsCross.gnu64.clonehero
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
    "slackow/apps/slackowwall"
  ];
}
