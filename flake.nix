{
  description = "Odilf's nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      nix-darwin,
      home-manager,
      agenix,
      nix-on-droid,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake =
        let
          nixosModule = {
            imports = [
              ./nix/modules
              ./nix/modules/polyfill/nixos.nix
              home-manager.nixosModules.default
              agenix.nixosModules.default
              {
                passthru.agenix-hm = agenix.homeManagerModules.default;
              }
            ];
          };

          darwinModule = {
            imports = [
              ./nix/modules
              ./nix/modules/polyfill/nix-darwin.nix
              home-manager.darwinModules.default
              agenix.darwinModules.default
              {
                passthru.agenix-hm = agenix.homeManagerModules.default;
              }
            ];
          };

          nixOnDroidModule = {
            imports = [
              ./nix/modules/polyfill/nix-on-droid.nix
              ./nix/modules
            ];
          };
        in
        {
          # Modules
          nixosModules.default = nixosModule;
          darwinModules.default = darwinModule;

          # Configurations
          nixosConfigurations = {
            "nixbook" = nixpkgs.lib.nixosSystem {
              system = "aarch64-linux";
              modules = [
                nixosModule
                ./nix/hosts/nixbook/configuration.nix
                inputs.apple-silicon.nixosModules.default
              ];
            };

            "ada" = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                nixosModule
                inputs.nixos-wsl.nixosModules.default
                ./nix/hosts/ada/configuration.nix
              ];
            };
          };

          darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = [
              darwinModule
              ./nix/hosts/macbook/configuration.nix
            ];
          };

          nixOnDroidConfigurations."vermeer" = nix-on-droid.lib.nixOnDroidConfiguration {
            pkgs = import nixpkgs { system = "aarch64-linux"; };
            modules = [
              nixOnDroidModule
              ./nix/hosts/vermeer/configuration.nix
            ];
          };
        };

      perSystem =
        { pkgs, system, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nil
              pkgs.nixd
              pkgs.jujutsu
              agenix.packages."${system}".default
            ];
          };
          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
