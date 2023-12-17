{
  description = "Fabian's Neovim Config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11";
  };
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = neovim.packages.x86_64-linux.neovim;
    apps.x86_64-linux.default = {
      type = "app";
      program = "${neovim.packages.x86_64-linux.neovim}/bin/nvim";
  };
}
