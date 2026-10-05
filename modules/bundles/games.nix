{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86;

  enabled = user: config.custom.bundles.${user}.games.enable;
  enabledForAnyUser = lib.any enabled (builtins.attrNames config.custom.bundles);
in
{
  boot.binfmt.emulatedSystems = lib.mkIf (!isx86 && enabledForAnyUser) [ "x86_64-linux" ];

  homebrew.casks = lib.optionals (isDarwin && enabledForAnyUser) [
    # TODO: Apparently it doesn't work in packages?? :(
    "prismlauncher"
    "epic-games"
    "minecraft"
    "steam"
    "dolphin"
    "clone-hero"
    "retroarch-metal"
  ];

  home-manager.users = lib.mapAttrs (
    user: _:
    lib.mkIf (enabled user) {
      home.packages = [
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
          # pkgs.pkgsCross.gnu64.clonehero
          pkgs.rare # Epic games GUI (linux)
          pkgs.dolphin-emu
          pkgs.retroarch # Broken on darwin
        ]
      );

      programs.mcsr.enable = true;
    }
  ) config.custom.bundles;
}
