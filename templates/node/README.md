# Node and TypeScript development environment

## Enter the environment

Inside a new or existing project directory, initialize this template with
`nix flake init -t /path/to/NixOS#node`. Replace the path with your config checkout.

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

- `pnpm init`: initialize a package.
- `pnpm add --save-dev typescript`: record the project's compiler version.
- `pnpm install`: install dependencies.
- `pnpm install --frozen-lockfile`: install without changing the dependency lock.
- `pnpm exec tsc --init`: create a TypeScript configuration.
- `pnpm exec tsc --noEmit`: type check once source files exist.
- `pnpm run`: list project-defined scripts; add `dev`, `test`, and `build` as needed.

`typescript-language-server` is available for Neovim. Commit `package.json`
and `pnpm-lock.yaml`. Nix pins Node and shell tooling; pnpm pins project
dependencies. Prefer the project's compiler through `pnpm exec` when present.

## Updates

Run `nix flake update` deliberately and commit the resulting `flake.lock`.
Existing projects retain their own locks when the workstation is rebuilt.
Keep language dependency lockfiles too; the development shell alone does not
pin application dependencies. Available on x86_64-linux and aarch64-linux.
