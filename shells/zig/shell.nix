{ pkgs ? import <nixpkgs> { } }:
{
  pkgs.mkShell = {
    nativeBuildInputs = with pkgs; [
      zig
      zls
    ];
    buildInputs = with pkgs; [
      SDL2
    ];
  };
}
