# TODO
# - [ ] Emulators
# - [ ] Steam
# - [x] Epic games
# - [ ] Terminal games

{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages.games;

  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86;
in
{
  options.packages.games = {
    enable = lib.mkEnableOption "Packages for gaming";

    emulators = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Emulators for retro consoles.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      [
        pkgs.smassh
        pkgs.vitetris # Kinda mediocre
        pkgs.terminal-parrot
      ]
      ++ lib.optionals (isLinux && isx86) [
        pkgs.steam-run
        pkgs.steam-tui
      ]
      ++ lib.optionals config.packages.gui (
        [
          pkgs.prismlauncher
          pkgs.legendary-gl
        ]
        ++ lib.optionals isLinux [
          pkgs.rare # Epic games GUI (linux)
          pkgs.dolphin-emu
        ]
      );

    homebrew.casks = lib.optionals isDarwin [
      "epic-games"
      "minecraft"
      "steam"
      "dolphin"
    ];
  };
}
