# Neovim cheatsheet

The leader is `Space`. Lua files in the checkout are editable without rebuilding;
restart Neovim to load changes. Nix package/theme changes require a rebuild.

| Keys | Action |
| --- | --- |
| Space f f | Find files |
| Space f g | Search file contents |
| Space n | Toggle file tree |
| jj in insert mode | Return to normal mode |
| Ctrl+S | Save |
| Ctrl+C in normal mode | Copy the whole file |
| Escape | Clear search highlight |
| [d / ]d | Previous / next diagnostic |
| Space e | Diagnostic details |
| Space q | Diagnostics list |
| gd | Definition, when a language server is attached |
| grr | References |
| K | Hover documentation |
| Space c r | Rename symbol |
| Space c a | Code action |
| Space c f | Format using project tools |
| Ctrl+Space in insert mode | Language completion |
| Ctrl+Y / Ctrl+E in completion | Accept / dismiss |
| `:ConfigHelp` | Personal documentation picker |

Language servers are enabled when their executable is on PATH: nixd,
pyright-langserver, gopls, rust-analyzer, and typescript-language-server. Native
LSP completion requires Neovim 0.11 or newer. Nix tooling is included with the
editor; other tools come from development shells. Enter the shell before
starting Neovim. Check `:checkhealth vim.lsp` when a server fails to attach.

Formatting is explicit, using nixfmt, Ruff, gofmt, rustfmt, StyLua, or Prettier
where available, with LSP formatting as a fallback. The fallback Rustfmt command uses edition 2021; use the project's `cargo fmt`
for its exact edition and configuration. Files are not automatically saved after formatting.
