{
  description = "Odilf's nix configs";

  inputs = {
    # TODO: Change this to nixpkgs-unstable and put in the other one in the server thing
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nix-darwin, ... }@inputs:
    {
      nixosConfigurations."uoh-server" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/uoh-server/configuration.nix
          ./nixos-modules
        ];
      };

      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/macbook.nix
          ./nixos-modules
        ];
      };
    };
}
