{ ... }:
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

    # This directory is symlinked out of the store (see home.nix) so the config
    # stays editable in place. Let Home Manager load its own generated Lua via
    # wrapper args instead of writing ~/.config/nvim/init.lua, which would
    # collide with that symlink.
    sideloadInitLua = true;
  };
}
