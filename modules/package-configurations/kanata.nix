{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
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
  services.kanata = lib.mkIf isLinux {
    enable = true;
    keyboards.main = {
      inherit config extraDefCfg;
    };
  };
}
