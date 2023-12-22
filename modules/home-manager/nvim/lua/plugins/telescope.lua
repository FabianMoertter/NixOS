-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
return {
  "nvim-telescope/telescope.nvim",
  config = function()
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    })
  end,
}
