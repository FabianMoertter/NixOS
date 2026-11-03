# Rust development environment

## Enter the environment

Inside a new or existing project directory, initialize this template with
`nix flake init -t /path/to/NixOS#rust`. Replace the path with your config checkout.

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

- `cargo init`: create a Rust project.
- `cargo check` / `cargo test`: check / test.
- `cargo fmt`: format.
- `cargo clippy -- -D warnings`: lint.
- `cargo run`: run the project.

`rust-analyzer` is available for Neovim. Commit `Cargo.toml` and, for
applications, `Cargo.lock`. This template uses the toolchain from pinned
nixpkgs; a `rust-toolchain.toml` does not select a different Nix toolchain.
Add a Rust overlay explicitly if a project requires an exact compiler release.
`pkg-config` and OpenSSL are included for common native dependencies.

## Updates

Run `nix flake update` deliberately and commit the resulting `flake.lock`.
Existing projects retain their own locks when the workstation is rebuilt.
Keep language dependency lockfiles too; the development shell alone does not
pin application dependencies. Available on x86_64-linux and aarch64-linux.
