{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;

    # Use the same nix-colors palette as the terminal. Keeping the palette here
    # avoids duplicating the Catppuccin flavour in the editable Lua config and
    # means both applications follow future colorScheme changes automatically.
    plugins = [ pkgs.vimPlugins.base16-nvim ];
    initLua = let
      inherit (config.colorScheme) palette;
    in
      ''
        vim.opt.termguicolors = true
        vim.cmd.packadd('base16-nvim')
        require('base16-colorscheme').setup({
          base00 = '#${palette.base00}',
          base01 = '#${palette.base01}',
          base02 = '#${palette.base02}',
          base03 = '#${palette.base03}',
          base04 = '#${palette.base04}',
          base05 = '#${palette.base05}',
          base06 = '#${palette.base06}',
          base07 = '#${palette.base07}',
          base08 = '#${palette.base08}',
          base09 = '#${palette.base09}',
          base0A = '#${palette.base0A}',
          base0B = '#${palette.base0B}',
          base0C = '#${palette.base0C}',
          base0D = '#${palette.base0D}',
          base0E = '#${palette.base0E}',
          base0F = '#${palette.base0F}',
        })
      '';

    # This directory is symlinked out of the store (see home.nix) so the config
    # stays editable in place. Let Home Manager load its own generated Lua via
    # wrapper args instead of writing ~/.config/nvim/init.lua, which would
    # collide with that symlink.
    sideloadInitLua = true;
  };
}
