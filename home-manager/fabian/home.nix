{ inputs, config, pkgs, ... }:
let
  # The repo is symlinked out of the store so configs stay editable in place.
  repo = "${config.home.homeDirectory}/Projects/NixOS/nixos-config";
in
{
  imports = [
    ../../modules/home-manager/cli.nix
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/misc.nix
    ../../nvim/neovim.nix
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-frappe;

  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";
    stateVersion = "23.11";

    file = {
      # My neovim config, kept writable outside the store
      ".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${repo}/nvim";
    };
  };

  programs.home-manager.enable = true;
}
