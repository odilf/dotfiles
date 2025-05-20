# TODO:
# - [ ] Matrix
# - [ ] Mail?
# - [ ] Terminal clients for all of the above

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
  users.users."*".packages =
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

  homebrew.casks = lib.optionals isDarwin [
    "whatsapp" # workaround
    "element"
    "thunderbird"
  ];
}
