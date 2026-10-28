# Roadmap

[Back to README](../README.md) ·
[Japanese input](japanese-input.md)

This roadmap describes the state of the configuration in the repository. The
order reflects dependencies between features, not fixed release dates.

## Current state

### NixOS and Home Manager

- [x] Pin NixOS and Home Manager to the 26.05 release through `flake.lock`.
- [x] Apply Home Manager as part of each NixOS rebuild.
- [x] Split host, user, shared system, CLI, desktop, and Neovim configuration.
- [x] Define the `lepidoptera` desktop and `hepidoptera` laptop as flake
  configurations with separate users and hardware configuration.
- [x] Define a reusable workstation baseline for audio, Bluetooth, networking,
  printing, Flatpak, OpenSSH, portals, and automatic Nix store maintenance.

### Command-line and editor environment

- [x] Configure Bash and Zsh, Git, tmux, Neovim, direnv, and nix-direnv through
  Home Manager.
- [x] Keep the editable Neovim configuration outside the Nix store while using
  a declarative Neovim package and theme.
- [x] Provide a permission-checking `with-openai-env` helper so API credentials
  are loaded only for the command that needs them.

### Desktop environment

- [x] Configure Hyprland input, key bindings, workspaces, screenshots, portals,
  and host-specific monitor layouts.
- [x] Configure Waybar, Rofi, SwayNotificationCenter, wallpaper management,
  Hyprlock, and automatic idle locking.
- [x] Retain a full desktop fallback: GNOME on `lepidoptera` and Plasma on
  `hepidoptera`.
- [x] Use a shared nix-colors palette for Kitty, Neovim, Waybar, Rofi, and lock
  surfaces.
- [x] Add Japanese input with Fcitx5 and Mozc to the shared workstation module
  and document its use.
- [x] Add an experimental Quickshell bar that can be toggled alongside Waybar.

## Next milestones

### 1. Consolidate the multi-host configuration

- [ ] Make the intended shared workstation imports consistent across the
  desktop and laptop.
- [ ] Verify the Hyprland session, display rules, input methods, locking, and
  suspend/resume behaviour on both active hosts.
- [ ] Refactor and expose `mantodea` as a flake configuration when its server
  role and storage layout are ready.
- [ ] Remove host-specific paths from shared Home Manager aliases and derive
  them from the active user's home directory.

### 2. Finish the theme contract and Quickshell shell

- [ ] Centralize fonts, icons, cursor, wallpaper, and GTK/Qt settings alongside
  the existing nix-colors palette.
- [ ] Add explicit, reproducible theme variants and a switching workflow.
- [ ] Expand the Quickshell bar to cover the workspace, system status, tray,
  audio, network, Bluetooth, and calendar features currently provided by
  Waybar.
- [ ] Add Quickshell launcher, notification, lock, and power surfaces and wire
  the existing Quickshell lock prototype into the session.
- [ ] Remove Waybar only after the Quickshell replacement reaches feature
  parity and is reliable on both hosts.

### 3. Secrets and AI tooling

- [ ] Add SOPS with age-based secrets management for system and Home Manager
  secrets; no secret material should be committed to the repository.
- [ ] Configure Codex and GitHub Copilot declaratively beyond installing their
  packages.
- [ ] Add reusable MCP and agent-tool configuration without embedding
  credentials.
- [ ] Make project-local AI tools available through development shells.

### 4. Reproducible development environments

- [ ] Add a repository development shell and formatter output to `flake.nix`.
- [ ] Add reusable language-specific shells or templates.
- [ ] Standardize formatter, language-server, test, and pre-commit workflows.
- [ ] Move project-specific compilers and runtimes out of the global Home
  Manager profile and into project development shells.

### 5. Validation and documentation

- [ ] Add flake checks that evaluate every supported host and Home Manager
  configuration.
- [ ] Run those checks in CI.
- [ ] Update the README host list and project tree to match the desktop,
  laptop, and shared-module layout.
- [ ] Add focused usage and architecture documentation as the configuration
  stabilizes.

## Ongoing principles

- Keep rebuilds reproducible and changes small enough to review.
- Keep credentials and host secrets out of Git.
- Preserve a working fallback desktop until the Hyprland/Quickshell workflow is
  dependable.
- Add abstractions only after more than one host, user, or project needs them.

## Project boundaries

- Impermanence is intentionally out of scope; system and home data use the
  conventional persistent filesystem layout.
