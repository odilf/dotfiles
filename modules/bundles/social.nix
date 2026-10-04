{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  utils = import ../utils.nix { inherit config lib pkgs; };
in
{
  users.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "social") {
      packages = [
        pkgs.nchat
        pkgs.discordo
      ]
      ++ lib.optionals isLinux [
        pkgs.termsonic
      ]
      ++ lib.optionals config.gui (
        lib.optionals isLinux [
          pkgs.signal-desktop
          pkgs.karere
          pkgs.element-desktop
        ]
        ++ lib.optionals isDarwin [
          # pkgs.whatsapp-for-mac # Fails to download
        ]
      );
    };

  home-manager.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "social") {
      programs = {
        gurk-rs.enable = true;
        meli.enable = true;
        # iamb.enable = true;
      };
    };

  homebrew.casks = lib.optionals (isDarwin && utils.bundleEnabled "social") [
    "whatsapp" # workaround
    "signal"
    "element"
  ];
}
