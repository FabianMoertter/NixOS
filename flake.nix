{
  description = "NixOS config for multiple devices";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    stylix.url = "github:danth/stylix/release-24.11";

    sops-nix.url = "github:Mic92/sops-nix";

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, nix-colors, stylix, ... }:

    let
      # theme = "dracula";
      # theme = "catppuccin-mocha";
      theme = "catppuccin-frappe";
      inherit (self) outputs;
      system = "x86_64-linux";
      user = "fabian";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib;
    in
    {

      # Your custom packages and modifications, exported as overlays
      # overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/system;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {

        # mini (home server)
        mantodea = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs pkgs-unstable; };
          modules = [
            outputs.nixosModules.homeServer
            outputs.nixosModules.mainUser
            ./systems/mini/configuration.nix
          ];
        };

        # fabian-laptop-2
        hymenoptera = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = (with outputs.nixosModules; [
            bluetooth
            gnome
            users
            mainUser
            salt
            virtualization
            steam
          ])
          ++
          ([ ./systems/laptop-2/configuration.nix ]);
        };

        # fabian-laptop
        coleoptera = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs theme pkgs-unstable; };
          modules = (with outputs.nixosModules; [
            bluetooth
            gnome
            users
            mainUser
          ])
          ++
          ([ ./systems/laptop-1/configuration.nix ]);
        };

        # fabian-desktop ( lepidoptera )
        lepidoptera = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs theme pkgs-unstable; };
          modules = (with outputs.nixosModules; [
            bluetooth
            gnome
            nvidia
            steam
            users
            mainUser
          ])
          ++
          ([
            ./systems/desktop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs outputs theme pkgs-unstable; };
              home-manager.users.fabian = import ./home-manager/fabian/home.nix;
            }
          ]);
        };

      };

      homeConfigurations = {

        "fabian@hymenoptera" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs theme pkgs-unstable; };
          modules = [
            ./home-manager/fabian/home.nix
          ];
        };

        "fabian@coleoptera" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs theme pkgs-unstable; };
          modules = [
            ./home-manager/fabian/home.nix
          ];
        };

      };
    };
}
