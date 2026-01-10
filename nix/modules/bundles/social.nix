{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  users.users."*" =
    { enableBundle, ... }:
    lib.mkIf (enableBundle "social") {
      packages = [
        pkgs.nchat
        pkgs.discordo
        pkgs.termsonic
      ]
      ++ lib.optionals config.gui (
        lib.optionals isLinux [
          pkgs.signal-desktop
          pkgs.wasistlos
          pkgs.element-desktop
          pkgs.thunderbird
        ]
        ++ lib.optionals isDarwin [
          # pkgs.whatsapp-for-mac # Fails to download
        ]
      );
    };

  home-manager.users."*".programs = {
    gurk-rs.enable = true;
    meli.enable = true;
    iamb.enable = true;
  };

  homebrew.casks = lib.optionals isDarwin [
    "whatsapp" # workaround
    "signal"
    "element"
    "thunderbird"
  ];
}
