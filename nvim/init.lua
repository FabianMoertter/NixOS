-- [[ Leader Key ]]
-- Note: Must happen before plugins arte required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Setting options ]]
require 'custom.options'
-- [[ Utils ]]
require 'custom.utils'
-- [[ Configure plugins ]]
require('lazy').setup('plugins')
-- [[ Additional plugin setup ]]
-- require(...)
-- [[ Basic Keymaps ]]
require 'custom.keymaps'

