{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin isx86;

  utils = import ../utils.nix { inherit config lib pkgs; };
in
{
  boot.binfmt.emulatedSystems = lib.mkIf (!isx86 && utils.bundleEnabled "games") [ "x86_64-linux" ];

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
          # pkgs.pkgsCross.gnu64.clonehero
          pkgs.rare # Epic games GUI (linux)
          pkgs.dolphin-emu
          pkgs.retroarch # Broken on darwin
        ]
      );
    };

  homebrew.casks = lib.optionals (isDarwin && utils.bundleEnabled "games") [
    # TODO: Apparently it doesn't work in packages?? :(
    "prismlauncher"
    "epic-games"
    "minecraft"
    "steam"
    "dolphin"
    "clone-hero"
    "retroarch-metal"
  ];

  home-manager.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "games") {
      programs.mcsr.enable = true;
    };
}
