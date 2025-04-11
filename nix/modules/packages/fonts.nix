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
      # Takes too long to build... and it's kind of ugly.
      # let
      #   iosevkaOdilf = (
      #     pkgs.iosevka.override {
      #       set = "Odilf";
      #       privateBuildPlan = builtins.readFile ../../../font/iosevka/private-build-plans.toml;
      #     }
      #   );
      # in
      {
        packages = [
          # iosevkaOdilf
          pkgs.nerd-fonts.iosevka-term
          pkgs.nerd-fonts.iosevka-term-slab
          pkgs.nerd-fonts.recursive-mono
          pkgs.nerd-fonts._0xproto
          pkgs.nerd-fonts.comic-shanns-mono
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
            monospace = [
              "IosevkaTerm Nerd Font"
              "RecMono Nerd Font"
              "ZedMono Nerd Font"
            ];
          };
        };

      };
  };
}
