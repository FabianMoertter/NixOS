{
  description = "NixOS config for my systems";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-colors,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      templateNames = [
        "minimal"
        "nix"
        "python"
        "go"
        "rust"
        "node"
      ];
    in
    {
      templates =
        nixpkgs.lib.genAttrs templateNames (name: {
          path = ./templates + "/${name}";
          description = "${name} development shell with direnv and documented commands";
          welcomeText = ''
            Read README.md, add the generated files to Git, then run direnv allow.
            Use nix develop if you prefer to enter the environment manually.
          '';
        })
        // {
          default = self.templates.minimal;
        };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              nixfmt
              nixd
              statix
              deadnix
              shellcheck
              shfmt
            ];
          };
        }
      );

      # Instantiate each template against this repository's pinned nixpkgs,
      # without fetching a separate lockfile for each generated project.
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          shellPaths = map (
            name:
            builtins.unsafeDiscardStringContext
              ((import (./templates + "/${name}/flake.nix")).outputs {
                inherit nixpkgs;
              }).devShells.${system}.default.drvPath
          ) templateNames;
        in
        {
          host-configurations =
            pkgs.runCommand "host-configuration-evaluation"
              {
                evaluatedHosts = builtins.concatStringsSep "\n" (
                  map
                    (
                      host:
                      builtins.unsafeDiscardStringContext
                        self.nixosConfigurations.${host}.config.system.build.toplevel.drvPath
                    )
                    [
                      "lepidoptera"
                      "hepidoptera"
                    ]
                );
              }
              ''
                test -n "$evaluatedHosts"
                touch "$out"
              '';
          workstation-dispatch =
            pkgs.runCommand "workstation-dispatch-tests"
              {
                nativeBuildInputs = [ pkgs.python3 ];
              }
              ''
                export PYTHONDONTWRITEBYTECODE=1
                python -m unittest discover -s ${./.}/tests -v
                touch "$out"
              '';
          template-contracts =
            pkgs.runCommand "template-contracts"
              {
                nativeBuildInputs = [ pkgs.nix ];
                # Force derivation evaluation, without building every toolchain.
                instantiatedShells = builtins.concatStringsSep "\n" shellPaths;
              }
              ''
                test -n "$instantiatedShells"
                for template in ${builtins.toString ./templates}/*; do
                  nix-instantiate --parse "$template/flake.nix" >/dev/null
                  test "$(cat "$template/.envrc")" = "use flake"
                  test -s "$template/.gitignore"
                  test -s "$template/README.md"
                done
                touch "$out"
              '';
        }
      );

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

      # fabian-server ( mantodea )
      # TODO

      # fabian-laptop ( hepidoptera )
      nixosConfigurations.hepidoptera = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./systems/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.fm = import ./home-manager/fm/home.nix;
          }
        ];
      };

    };
}
