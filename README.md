# Dotfiles

My dotfiles.

Install nix, then run the appropiate command

```bash
# Nixbook
sudo nixos-rebuild switch --flake "github:odilf/dotfiles?dir=nix#nixbook"

# Macbook
nix run nix-darwin -- switch --flake "github:odilf/dotfiles?dir=nix#macbook"

# UOH server
sudo nixos-rebuild switch --flake "github:odilf/dotfiles?dir=nix#uoh-server"
```

Then a fish alias is created so you can just type

```bash
rebuild
```
