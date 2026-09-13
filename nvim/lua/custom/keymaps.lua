-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- escape with 'jj' in insert mode
vim.keymap.set('i', 'jj', '<ESC>', { silent = true })

-- delete with x does not push in register ( interferes with xp to swap chars! )
-- vim.keymap.set('n', 'x', '"_x', { silent = true })

-- delete text without yanking
vim.keymap.set('n', '<leader>d', '"_d', { silent = true, noremap = true })

-- ESC to undo highlighting
vim.keymap.set('n', '<ESC>', '<cmd> noh <CR>', { silent = true })

-- navigate within insert mode
vim.keymap.set('i', '<C-h>', '<Left>', { silent = true, desc = 'move left in insert mode' })
vim.keymap.set('i', '<C-l>', '<Right>', { silent = true, desc = 'move right in insert mode' })
vim.keymap.set('i', '<C-j>', '<Down>', { silent = true, desc = 'move down in insert mode' })
vim.keymap.set('i', '<C-k>', '<Up>', { silent = true, desc = 'move up in insert mode' })

-- go to  beginning and end
vim.keymap.set('i', '<C-b>', '<ESC>^i', { silent = true, desc = 'move to beginning of line' })
vim.keymap.set('i', '<C-e>', '<End>', { silent = true, desc = 'move to end of line' })

-- save with CTRL+s
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', { silent = true, desc = 'save file' })

-- Copy all
vim.keymap.set('n', '<C-c>', '<cmd> %y+ <CR>', { silent = true, desc = 'copy whole file' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- substitute ( does not work )
-- vim.keymap.set('n', 'S', '<cmd> %s// <Left>', { silent = true, desc = '' })
-- vim.keymap.set('n', 'S', ':%s// <Left>', { silent = true, desc = '' })

-- switch between windows
-- vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
-- vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })
-- vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
-- vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })

