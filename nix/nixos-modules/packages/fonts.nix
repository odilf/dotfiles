# TODO

{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages.fonts;

  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  options.packages.fonts = {
    enable = lib.mkEnableOption "Packages for gaming";
    # TODO: 
    # default =  
  };

  config = lib.mkIf cfg.enable {
    fonts =
      {
        packages = [
          # Mono
          (pkgs.nerdfonts.override {
            fonts = [
              "0xProto"
              "ComicShannsMono"
              "GeistMono"
              "ZedMono"
            ];
          })
          pkgs.monocraft

          # Sans
          pkgs.poppins

          # Serif
          pkgs.lora
          pkgs.libertinus
        ];


            fontconfig = lib.mkIf isLinux {
              defaultFonts = {
                serif = [
                  "Lora"
                  "Libertinus"
                ];
                sansSerif = [
                  "Poppins"
                ];
                monospace = [ "" ];
              };
            };

      };
  };
}
