{
  description = "NixOS config for multiple devices";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, sops-nix, nix-colors, ... }@inputs:

    let
      # theme = "dracula";
      theme = "catppuccin-frappe";
      # theme = "catppuccin-mocha";
      inherit (self) outputs;
      system = "x86_64-linux";
      user = "fabian";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      lib = nixpkgs.lib;

    in {

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
          specialArgs = { inherit inputs outputs; };
          modules = [
            # outputs.nixosModules.homeServer
            outputs.nixosModules.mainUser
            ./systems/mini/configuration.nix
          ];
        };

        # fabian-laptop-2
        hymenoptera = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            outputs.nixosModules.bluetooth
            outputs.nixosModules.gnome
            outputs.nixosModules.users
            outputs.nixosModules.mainUser
            ./systems/laptop-2/configuration.nix
          ];
        };

        # fabian-laptop
        coleoptera = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs theme; };
          modules = [
            outputs.nixosModules.mainUser
            ./systems/laptop/configuration.nix
          ];
        };

        # fabian-desktop ( lepidoptera )
        lepidoptera = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs theme; };
          modules = [
            outputs.nixosModules.bluetooth
            outputs.nixosModules.gnome
            outputs.nixosModules.nvidia
            outputs.nixosModules.steam
            outputs.nixosModules.users
            outputs.nixosModules.mainUser
            # outputs.nixosModules.DNS
            ./systems/desktop/configuration.nix
          ];
        };

      };

      homeConfigurations = {

        "fabian@hymenoptera" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs theme; };
          modules = [
            ./home-manager/fabian/home.nix
          ];
        };

        "fabian@lepidoptera" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs theme; };
          modules = [
            ./home-manager/fabian/home.nix
          ];
        };

        "fabian@coleoptera" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs theme; };
          modules = [
            ./home-manager/fabian/home.nix
          ];
        };

      };
  };
}
