{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.05;
  };

  outputs = { self, nixpkgs }:
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.${system}.default = pkgs.mkShell {
          buildInputs = with pkgs; [
	  R
	  rPackages.GenomicRanges
	  rPackages.doParallel
	  rPackages.plyranges
	  rPackages.rtracklayer
	  rPackages.tidyverse
	  ];

          shellHook = ''
	  	echo 'nix flake with some R packages'
	  	echo on host: `hostname`
          '';
        };
  };
}
