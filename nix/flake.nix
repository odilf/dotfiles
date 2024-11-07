{
  description = "Odilf's nix configs";

  inputs = {
    # TODO: Change this to nixpkgs-unstable and put in the other one in the server thing
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    flake-utils.url = "github:numtide/flake-utils";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    churri = {
      url = "github:odilf/churri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sentouki = {
      url = "github:odilf/sentouki";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      flake-utils,
      ...
    }@inputs:
    {
      nixosConfigurations."uoh-server" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/uoh-server/configuration.nix
          ./nixos-modules
          ./nixos-modules/polyfill/nix-darwin.nix
          inputs.churri.nixosModules.default
          inputs.sentouki.nixosModules.default
        ];
      };

      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/macbook.nix
          ./nixos-modules
          ./nixos-modules/polyfill/nixos.nix
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
