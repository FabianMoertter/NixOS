# Python development environment

## Enter the environment

Inside a new or existing project directory, initialize this template with
`nix flake init -t /path/to/NixOS#python`. Replace the path with your config checkout.

```sh
# If this is a new project:
git init
# Git flakes only include tracked files. Add the generated files first:
git add flake.nix .envrc .gitignore README.md
nix flake lock
git add flake.lock
direnv allow
```

Review `.envrc` before allowing it. With nix-direnv configured, entering the
project directory activates its cached environment. For a manual session use
`nix develop`; for one command use `nix develop --command <command> [args...]`.
Start `nvim` from the activated shell so it inherits the tools on PATH.
A GUI project launcher must also enter the environment before starting Neovim.

## Daily commands

- `uv init`: create a Python project.
- `uv add --dev pytest`: add the test runner and record it in `uv.lock`.
- `uv sync`: install dependencies from the project lockfile.
- `uv run python`: run Python in the project virtual environment.
- `uv run pytest`: run tests after adding pytest.
- `ruff check .` / `ruff format .`: lint / format.
- `pyright`: type check; `pyright-langserver` is available for Neovim.

The shell sets `UV_PYTHON_DOWNLOADS=never` and `UV_PYTHON` to its Nix Python.
Nix pins the interpreter/tools; commit `pyproject.toml` and `uv.lock` to pin
Python dependencies. `.venv` stays local. Native dependencies may require
additional packages or environment variables in `flake.nix`.

## Updates

Run `nix flake update` deliberately and commit the resulting `flake.lock`.
Existing projects retain their own locks when the workstation is rebuilt.
Keep language dependency lockfiles too; the development shell alone does not
pin application dependencies. Available on x86_64-linux and aarch64-linux.
