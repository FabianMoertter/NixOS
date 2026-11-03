# Go development environment

## Enter the environment

Inside a new or existing project directory, initialize this template with
`nix flake init -t /path/to/NixOS#go`. Replace the path with your config checkout.

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

- `go mod init example.com/project`: initialize a module (choose your own path).
- `go test ./...`: run tests.
- `go build ./...`: compile packages.
- `gofmt -w .`: format.
- `staticcheck ./...`: run additional analysis.
- `dlv debug`: debug a main package.

`gopls` is available for Neovim. Commit `go.mod` and `go.sum` alongside
`flake.lock`; the shell pins tooling, while Go manages module dependencies.

## Updates

Run `nix flake update` deliberately and commit the resulting `flake.lock`.
Existing projects retain their own locks when the workstation is rebuilt.
Keep language dependency lockfiles too; the development shell alone does not
pin application dependencies. Available on x86_64-linux and aarch64-linux.
