{ ... }:
{
  # Home Manager modules for programs that don't have a stock module yet.
  # Theoreitcally, candidates for upstreaming. In practice, these are pretty
  # niche.
  imports = [
    ./karabiner.nix
    ./mcsr.nix
  ];
}
