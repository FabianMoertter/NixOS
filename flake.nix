{
  description = "NixOS config for my systems";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

  };

  outputs = { self, nixpkgs, home-manager, nix-colors, ... }@inputs:
    {

      # fabian-desktop ( lepidoptera )
      nixosConfigurations.lepidoptera = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./systems/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.fabian = import ./home-manager/fabian/home.nix;
          }
        ];
      };

    };
}
