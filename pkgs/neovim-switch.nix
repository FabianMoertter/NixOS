{ pkgs }:

pkgs.writeShellScriptBin "test-script" ''
  echo "hello world" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
''
