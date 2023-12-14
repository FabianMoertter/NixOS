# https://ghedam.at/15978/an-introduction-to-nix-shell
with (import <nixpkgs> {});
mkShell {
  buildInputs = [
  ];
  shellHook = ''
    echo "Hello"
  '';
}
