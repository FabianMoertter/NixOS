{ pkgs, ... }:
{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline  vimwiki vim-tmux-navigator ];
    settings = {
      number = true;
      relativenumber = true;
      tabstop = 2;
    };
    extraConfig = ''
      set mouse=a
      let mapleader = " "
      let g:vimwiki_list = [ { 'path': '$HOME/Projects/Neovim/vimwiki' } ]
    '';
  };
}
