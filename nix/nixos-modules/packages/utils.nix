{
  # * Use nixpkgs package in linux and homebrew cask in darwin
  pkgOrCask = pkg: cask: {
    inherit pkg cask;
  };

  mkPkgs = pkgs: builtins.map (pkg: if pkg ? pkg then pkg.pkg else pkg) pkgs;

  mkCasks = pkgs: builtins.map ({ cask, ... }: cask) (builtins.filter (pkg: pkg ? cask) pkgs);
}
