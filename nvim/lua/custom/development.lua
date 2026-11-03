-- Tooling comes from the active project's devshell; nothing is downloaded here.
local servers = {
  nixd = { cmd = { 'nixd' }, filetypes = { 'nix' }, root_markers = { 'flake.nix', '.git' } },
  python = { cmd = { 'pyright-langserver', '--stdio' }, filetypes = { 'python' }, root_markers = { 'pyproject.toml', '.git' } },
  go = { cmd = { 'gopls' }, filetypes = { 'go', 'gomod', 'gowork' }, root_markers = { 'go.work', 'go.mod', '.git' } },
  rust = { cmd = { 'rust-analyzer' }, filetypes = { 'rust' }, root_markers = { 'Cargo.toml', '.git' } },
  typescript = { cmd = { 'typescript-language-server', '--stdio' }, filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }, root_markers = { 'package.json', '.git' } },
}

if vim.fn.has('nvim-0.11') == 1 then
  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
  end
  -- Check PATH on buffer entry too, so a newly allowed direnv shell works on restart.
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(event)
      for name, server in pairs(servers) do
        if vim.tbl_contains(server.filetypes, vim.bo[event.buf].filetype)
          and vim.fn.executable(server.cmd[1]) == 1 then
          vim.lsp.enable(name)
        end
      end
    end,
  })
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
      end
      local function map(key, action, description)
        vim.keymap.set('n', key, action, { buffer = event.buf, desc = description })
      end
      map('gd', vim.lsp.buf.definition, 'Go to definition')
      map('grr', vim.lsp.buf.references, 'Find references')
      map('K', vim.lsp.buf.hover, 'Documentation')
      map('<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
      map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    end,
  })
end

vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { desc = 'Complete from language server' })

vim.keymap.set('n', '<leader>cf', function()
  local file = vim.api.nvim_buf_get_name(0)
  local formatters = {
    nix = { 'nixfmt' },
    python = { 'ruff', 'format', '--stdin-filename', file, '-' },
    go = { 'gofmt' },
    rust = { 'rustfmt', '--emit', 'stdout', '--edition', '2021' },
    lua = { 'stylua', '-' },
  }
  local ft = vim.bo.filetype
  local cmd = formatters[ft]
  if vim.tbl_contains({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'markdown' }, ft) then
    cmd = { 'prettier', '--stdin-filepath', file }
  end
  if cmd and vim.fn.executable(cmd[1]) == 1 then
    local result = vim.system(cmd, { text = true, stdin = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n') .. '\n' }):wait()
    if result.code ~= 0 then
      vim.notify(result.stderr, vim.log.levels.ERROR)
      return
    end
    local lines = vim.split(result.stdout, '\n')
    if lines[#lines] == '' then table.remove(lines) end
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.fn.winrestview(view)
  elseif #vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/formatting' }) > 0 then
    vim.lsp.buf.format()
  else
    vim.notify('No formatter on PATH. Enter the project devshell and restart Neovim.', vim.log.levels.WARN)
  end
end, { desc = 'Format buffer using project tooling' })

vim.api.nvim_create_user_command('ConfigHelp', function()
  vim.fn.jobstart({ 'config-help' }, { detach = true })
end, { desc = 'Search personal configuration documentation' })
