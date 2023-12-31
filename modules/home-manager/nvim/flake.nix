{
  description = "Fabian's Neovim Config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/";
    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, neovim }: {
    packages.x86_64-linux.default = neovim.packages.x86_64-linux.neovim;
    apps.x86_64-linux.default = {
      type = "app";
      program = "${neovim.packages.x86_64-linux.neovim}/bin/nvim";
    };
  };
}
