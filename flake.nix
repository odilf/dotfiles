{
  description = "Odilf's nix configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

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
      flake-parts,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake = rec {
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
      };

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nil
              pkgs.nixd
              pkgs.jujutsu
            ];
          };
          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
