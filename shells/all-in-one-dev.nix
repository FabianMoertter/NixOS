{ pkgs ? import <nixpkgs> {} }:
{
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages = [
      ruby_3_2
      python3.10
    ];
  };

  # buildInputs is for dependencies you'd need "at run time",
  # were you to to use nix-build not nix-shell and build whatever you were working on
  buildInputs = [
    (import ./my-expression.nix { inherit pkgs; })
  ];

}
