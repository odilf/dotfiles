{ pkgs, ... }:
{
  home.stateVersion = "24.11";
  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
      bun
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  home.packages = with pkgs; [
    bun
    dart-sass
    fd
    brightnessctl
    swww
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
  ];
}
