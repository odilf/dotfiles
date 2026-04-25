{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  config = ''
    (defsrc
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    ret
      caps a    s    d    f    g    h    j    k    l    ;    '    \    ;;ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl  lalt lmet          spc        rmet ralt 
    )

    (deflayermap (main)
      tab @tab
      caps @cap
    )

    (deflayer arrows
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    left down up   rght _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _              _          _    _
    )


    (defalias
      cap-inner (tap-hold-press 0 200 esc lctrl)
      cap (multi f24 @cap-inner) ;; workaround https://github.com/jtroo/kanata/discussions/422

      tab (tap-hold-press 200 200 tab (layer-while-held arrows))
    )
  '';
  extraDefCfg = "process-unmapped-keys yes";
in
{
  services.kanata = {
    enable = true;
    keyboards.main = lib.mkIf isLinux {
      inherit config extraDefCfg;
    };

    kanata-bar.enable = lib.mkIf isDarwin true;
    # Adapted from https://github.com/NixOS/nixpkgs/blob/10e7ad5bbcb421fe07e3a4ad53a634b0cd57ffac/nixos/modules/services/hardware/kanata.nix#L98-L109
    configSource = lib.mkIf isDarwin (
      pkgs.writeText "kanata-main-config.kbd" ''
        (defcfg
            ${extraDefCfg}
            linux-continue-if-no-devs-found yes)

        ${config}
      ''
    );
  };
}
