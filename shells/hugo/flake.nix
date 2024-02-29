{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.11;
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          hugo
        ];

        shellHook = ''
          echo on host: `hostname`
        '';
      };
    };
}
