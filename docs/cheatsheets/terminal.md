# Terminal cheatsheet

Ghostty renders windows; tmux keeps sessions alive when you close a terminal.

| Command | Action |
| --- | --- |
| `project` | Select a project |
| `project PATH` | Open a directory as a persistent session |
| `project new` | Choose a development template |
| `project sessions` | Resume a tmux session |
| `z NAME` | Jump to a frequently visited directory |
| `Ctrl+R` in Zsh | Search shell history with fzf |
| `nixconfig` | Go to this configuration checkout |
| `vimconfig` | Go to editable Neovim configuration |
| `lg` | Lazygit |
| `config-help` | Search configuration documentation |

The tmux prefix is `Ctrl+A`. Release it before pressing the next key.

| Keys after prefix | Action |
| --- | --- |
| h / j / k / l | Focus pane |
| - | Split into panes side by side |
| _ | Split into panes stacked vertically |
| c | New window |
| 1…9 | Select window |
| d | Detach, leaving session running |
| [ | Enter copy/scroll mode; q exits |
| ? | All tmux bindings |

Neovim and tmux use `Ctrl+H/J/K/L` for navigation between editor splits and panes
in normal mode. Zsh starts in vi insert mode; `Escape` enters command mode.
