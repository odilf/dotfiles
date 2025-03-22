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
  };

  config = lib.mkIf cfg.enable {
    fonts =
      let
        iosevkaOdilf = (
          pkgs.iosevka.override {
            set = "Odilf";
            privateBuildPlan = builtins.readFile ../../../font/iosevka/private-build-plans.toml;
          }
        );
      in
      {
        packages = [
          iosevkaOdilf
          pkgs.nerd-fonts._0xproto
          pkgs.nerd-fonts.comic-shanns-mono
          pkgs.nerd-fonts.geist-mono
          pkgs.nerd-fonts.zed-mono
          pkgs.monocraft

          # Sans
          pkgs.atkinson-hyperlegible
          pkgs.poppins

          # Serif
          pkgs.lora
          pkgs.libertinus
        ];

        fontconfig = lib.mkIf isLinux {
          defaultFonts = {
            serif = [
              "Libertinus"
              "Lora"
            ];
            sansSerif = [
              "Atkinson Hyperlegible"
              "Poppins"
            ];
            monospace = [ "ZedMono Nerd Font" ];
          };
        };

      };
  };
}
