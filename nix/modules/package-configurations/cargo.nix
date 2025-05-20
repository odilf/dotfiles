{ ... }:
{
  home-manager.users."*".home.file.".cargo/config.toml" = {
    text = ''build.target-dir = "$HOME/.cargo/.global-cache"'';
  };
}
