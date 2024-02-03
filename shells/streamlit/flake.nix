{
  description = "Flake for simple streamlit applications";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pyPkgs = pythonPackages: with pythonPackages; [
        pandas
        matplotlib
        numpy
        plotly
        seaborn
      ];
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = [
            (pkgs.python3.withPackages pyPkgs)
            pkgs.streamlit
          ];
        };
      };
    };
}
