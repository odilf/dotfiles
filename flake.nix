{
  description = "Odilf's nix configs";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
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

    niri-session-manager = {
      url = "github:MTeaHead/niri-session-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    };

    kanata-darwin = {
      url = "github:not-in-stock/kanata-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      nix-darwin,
      home-manager,
      agenix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      flake =
        let
          nixosModule = {
            imports = [
              ./modules
              ./modules/polyfill/nixos.nix
              home-manager.nixosModules.default
              agenix.nixosModules.default
              inputs.niri-session-manager.nixosModules.niri-session-manager
              {
                passthru.agenix-hm = agenix.homeManagerModules.default;
              }
            ];
          };

          darwinModule = {
            imports = [
              ./modules
              ./modules/polyfill/nix-darwin.nix
              home-manager.darwinModules.default
              agenix.darwinModules.default
              inputs.kanata-darwin.darwinModules.default
              {
                passthru.agenix-hm = agenix.homeManagerModules.default;
              }
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
                ./hosts/nixbook/configuration.nix
                inputs.apple-silicon.nixosModules.default
              ];
            };

            "ada" = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                nixosModule
                inputs.nixos-wsl.nixosModules.default
                ./hosts/ada/configuration.nix
              ];
            };
          };

          darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = [
              darwinModule
              ./hosts/macbook/configuration.nix
            ];
          };
        };

      perSystem =
        {
          pkgs,
          system,
          lib,
          ...
        }:
        let
          packageSet = import ./modules/derivations/default.nix {
            inherit pkgs lib;
          };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nil
              pkgs.nixd
              pkgs.nix-update
              agenix.packages.${system}.default
            ];
          };
          formatter = pkgs.nixfmt;

          # `firefox-addons` and `helix-plugins` are attrsets of derivations,
          # which `packages` can't hold as-is (flake checks reject nested
          # attrsets), so they're flattened here. That also lets nix-update
          # (which only resolves flat `packages.<system>.<attr>`) reach each
          # entry. Modules use the nested form via the overlay in
          # modules/default.nix as `pkgs.firefox-addons.<name>` /
          # `pkgs.helix-plugins.<name>`.
          packages =
            lib.removeAttrs packageSet [
              "firefox-addons"
              "helix-plugins"
              "ninjabrain-bot-app"
            ]
            // packageSet.firefox-addons
            // packageSet.helix-plugins;

          legacyPackages = packageSet;
        };
    };
}
