# TODO:
# - [ ] gurk-rs for signal on terminal
# - [ ] matrix terminal
# - [ ] Mail terminal

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
      packages =
        # discord ommited, just use the web app.
        [
          pkgs.nchat
        ]
        ++ lib.optionals config.gui (
          lib.optionals isLinux [
            pkgs.signal-desktop
            pkgs.whatsapp-for-linux
            pkgs.element-desktop
            pkgs.thunderbird
          ]
          ++ lib.optionals isDarwin [
            # pkgs.whatsapp-for-mac # Fails to download
          ]
        );
    };

  homebrew.casks = lib.optionals isDarwin [
    "whatsapp" # workaround
    "signal"
    "element"
    "thunderbird"
  ];
}
