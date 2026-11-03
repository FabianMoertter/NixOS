# Development environments

`project` selects directories under `~/Projects` and one directory level below
each child. It creates a tmux session with shell and editor windows, or resumes
an existing session. `project /absolute/path` opens a specific directory;
`project sessions` selects an existing tmux session. In Hyprland the picker uses
Rofi; without a Wayland display it uses fzf.

## Create a project

Use Actions → Development → New project from template, or run `project new`.
The interactive helper creates a new directory under your configured Projects
root and refuses to overwrite an existing directory.

For direct initialization in an empty directory:

```sh
nix flake init -t /path/to/NixOS#python
git init
git add flake.nix .envrc .gitignore README.md
nix flake lock
# Review .envrc before allowing its execution.
direnv allow
```

The generated project owns its `flake.lock`; commit it together with the
language's dependency lockfile. Automatic activation uses nix-direnv. Use
`nix develop` for a manual shell. Inside an existing tmux session, leave/reenter
the project directory or run `direnv reload` after changing its environment.
Restart Neovim after changing the toolchain so it inherits the new PATH.

| Template | Tools |
| --- | --- |
| minimal | Basic shell and Git |
| nix | Nix formatter, language server, static checks |
| python | Python, uv, Ruff, Pyright |
| go | Go, gopls, Delve |
| rust | Cargo, rustc, rust-analyzer, rustfmt, Clippy |
| node | Node, pnpm, TypeScript server, Prettier |

Each template README gives its exact format/test/run commands. Runtimes already
in the global profile remain available for compatibility; new projects should
put their dependencies in their own shells.

## Work on this configuration

```sh
direnv allow
nix fmt
nix build .#checks.x86_64-linux.template-contracts --no-link
nix eval --raw .#nixosConfigurations.hepidoptera.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.lepidoptera.config.system.build.toplevel.drvPath
```

The template contract check instantiates all six shells against the repository's
pinned nixpkgs and checks their scaffold files. It does not build all language
toolchains or run tests for applications that have not been created yet.
