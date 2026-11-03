# Configuration architecture

The flake defines two NixOS hosts and applies Home Manager during the same
rebuild. Host files own hardware and system services; user files select shared
Home Manager modules and personal paths.

| Location | Responsibility |
| --- | --- |
| `systems/desktop`, `systems/laptop` | Host configuration and hardware |
| `modules/system` | Shared operating system services |
| `home-manager/fabian`, `home-manager/fm` | User imports and checkout location |
| `modules/home-manager/workstation.nix` | Shared path and motion options |
| `modules/home-manager/actions.nix` | Action registry, command wrappers, generated help |
| `scripts/workstation.py` | Rofi/fzf selection, project sessions, utilities, help |
| `modules/home-manager/study.nix` | Study command, Firefox learning profile, Anki |
| `modules/home-manager/theme.nix` | Palette, fonts, GTK/Qt, wallpaper helpers |
| `modules/home-manager/ghostty.nix` | Terminal rendering and shell integration |
| `modules/home-manager/cli.nix` | Zsh, tmux, Git, navigation and direnv |
| `nvim` | Editable Lua plus declarative package/theme/tooling |
| `templates` | Standalone project flakes |

## Commands and shortcuts

`workstation.actions` maps stable IDs to category, label, argument list,
description, and optional shortcut. The picker dispatches selected IDs without
evaluating labels as shell code. Add or override actions in a Home Manager module:

```nix
workstation.actions.notes = {
  category = "Learning";
  label = "Notes";
  description = "Open my notes application";
  argv = [ "iotas" ];
};
```

Actions are available through `workstation-action ID`. Their generated table is
installed at `~/.local/share/workstation/actions.md` and exposed in `config-help`.
The optional shortcut describes a binding; it does not create a Hyprland binding.
Desktop bindings themselves live in `hyprland.nix`.

## Theme and runtime state

Nix owns the Catppuccin Frappe palette used by Ghostty, tmux, Neovim, Rofi,
Quickshell, borders, and notifications. The runtime theme picker changes GTK's
light/dark preference and wallpaper; it does not regenerate that palette.
Reduced motion disables the configured desktop/widget animations and cursor
blink and uses immediate wallpaper transitions.

Quickshell supplies the bar and a PAM-backed Wayland session lock. Hypridle
requests locking before suspend. Keep multi-monitor lock and suspend/resume
checks in the manual verification routine when changing the lock implementation.

## Inspiration

- [fufexan/dotfiles](https://github.com/fufexan/dotfiles): NixOS/Home Manager organization and desktop widgets.
- [Misterio77/Foundry](https://github.com/Misterio77/Foundry): shared desktop modules and theming.
- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland): Quickshell interaction and visual ideas.
- [the-nix-way/dev-templates](https://github.com/the-nix-way/dev-templates): language shell scaffolds.
