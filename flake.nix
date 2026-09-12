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

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-colors, stylix, ... }:

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

    };
}
