{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    withPython3 = false;
    withNodeJs = false;
    extraLuaConfig = ''
      -- Write lua code here
    '';

     plugins = with pkgs.vimPlugins; [

     {
       plugin = nvim-web-devicons;
     }

     {
       plugin = nvim-lspconfig;
     }

     {
       plugin = neorg;
     }

     {
       plugin = comment-nvim;
       type = "lua";
       config = "require('Comment').setup({ ignore = '^$', })";
     }

     {
       plugin = vim-tmux-navigator;
     }

     {
       plugin = vim-surround;
     }

     {
       plugin = alpha-nvim;
     }

     {
       plugin = nvim-treesitter;
       type = "lua";
       config = "require('nvim-treesitter').setup(
       {
         ensure_installed = {
           'c',
           'lua',
           'python',
           'bash',
           'vim',
           'nix',
         },
         incremental_selection = {
           enable = true,
         },
       })";
     }

     ];

  };
}
