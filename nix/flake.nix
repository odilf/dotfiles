{
  description = "Odilf's nix configs";

  inputs = {
    # TODO: Change this to nixpkgs-unstable and put in the other one in the server thing
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nix-darwin, ... }: {

    nixosConfigurations."uoh" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configurations/uoh/configuration.nix
      ];
    };

    darwinConfigurations."Odysseass-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ ./darwin-configuration.nix ];
    };
  };
}
