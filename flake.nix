{
  description = "Odilf's nix configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    flake-utils.url = "github:numtide/flake-utils";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    rec {

      # Modules
      nixosModules.default = {
        imports = [
          ./nix/modules
          ./nix/modules/polyfill/nixos.nix
          home-manager.nixosModules.default
        ];
      };

      darwinModules.default = {
        imports = [
          ./nix/modules
          ./nix/modules/polyfill/nix-darwin.nix
          home-manager.darwinModules.default
        ];
      };

      # Configurations
      nixosConfigurations."nixbook" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./nix/hosts/nixbook/configuration.nix
          nixosModules.default
          inputs.apple-silicon.nixosModules.default
        ];
      };

      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/hosts/macbook/configuration.nix
          darwinModules.default
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nil
            pkgs.nixd
          ];
        };
        formatter = pkgs.nixfmt-rfc-style;

      }
    );
}
