Polyfills to make different systems work with the same config.

They way they are organized is that the file name corresponds to what machine needs to be applied to. So, you need to include `nix-darwin` on darwin machines, and `nixos.nix` in nixos machines. 

In the future there might be also a `i686.nix`, which would need to be applied in addition to `nixos.nix`. 
