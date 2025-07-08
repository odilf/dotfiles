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

    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-24-05.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager-24-05 = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # nix-on-droid = {
    #   url = "github:nix-community/nix-on-droid/release-24.05";
    #   inputs.nixpkgs.follows = "nixpkgs-24-05";
    #   inputs.home-manager.follows = "home-manager-24-05";
    # };
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      nix-darwin,
      home-manager,
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
            ];
          };

          darwinModule = {
            imports = [
              ./nix/modules
              ./nix/modules/polyfill/nix-darwin.nix
              home-manager.darwinModules.default
            ];
          };

          nixOnDroidModule = {
            imports = [
              # inputs.home-manager-24-05.nixosModules.default
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
          nixosConfigurations."nixbook" = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              nixosModule
              ./nix/hosts/nixbook/configuration.nix
              inputs.apple-silicon.nixosModules.default
            ];
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
