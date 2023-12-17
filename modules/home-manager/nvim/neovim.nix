{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    withPython3 = false;
    # extraPython3Packages  = pyPkgs: with pyPkgs; [ python-language-server ];
    withNodeJs = false;
    withRuby = false;
  };
}
