# TODO

{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.packages.fonts;

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
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

      }
      # Annoying bodgy thing because nix-darwin complains `fontconfig` is not known even if it doesn't use it. 
      // (
        if isLinux then
          {
            fontconfig = {
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
          }
        else
          { }
      );
  };
}
