{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  home-manager.users."*".programs.ghostty = {
    package = lib.mkIf (!isLinux) null;
    settings = {
      font-family = "IosevkaTerm Nerd Font";
      font-style = "Regular";
      command = "${pkgs.fish}/bin/fish";
      shell-integration = "fish";
      theme =
        let
          light = "Bluloco Light";
          dark = "Horizon";
        in
        "light:${light},dark:${dark}";
      font-size = if isDarwin then 16 else 12;
      window-decoration = "none";
      macos-option-as-alt = "left";
      adjust-underline-thickness = 1;

      quit-after-last-window-closed = true;
      macos-window-shadow = false;
      mouse-hide-while-typing = true;

      gtk-single-instance = true;
    };
  };
}
