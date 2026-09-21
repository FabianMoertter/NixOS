# Roadmap

[Back to README](../README.md) · [Usage](usage.md) ·
[Architecture](architecture.md) · [Secrets](secrets.md)

This project is intentionally built in small, independently usable milestones.
The ordering below reflects dependencies between features, not fixed release
dates.

## Completed foundations

- [x] Enable the modern Nix command and flakes
- [x] Convert the system to a pinned flake
- [x] Integrate Home Manager into NixOS rebuilds
- [x] Separate host, user, CLI, and desktop configuration
- [x] Establish the Bash-based CLI toolset
- [x] Enable direnv and nix-direnv
- [x] Add a repository development shell and formatter
- [x] Add project documentation
- [x] Add SOPS and age-based secrets management
- [x] Verify system and Home Manager secret declarations with a test value

## Planned milestones

### Hyprland desktop

- Configure the Hyprland session, portals, environment, input, displays, and
  essential user services.
- Retain Plasma as a fallback until the Hyprland workflow is complete.
- Move Waybar out after Quickshell provides equivalent functionality.

### Theme system and Quickshell

- Define a single theme source for colors, fonts, icons, cursor, wallpaper, and
  toolkit settings.
- Support explicit, reproducible theme variants and quick switching.
- Build the Quickshell bar, launcher, notifications, lock and power surfaces
  against that shared theme contract.

### AI integration

- Configure Codex and GitHub Copilot declaratively where practical.
- Add reusable MCP and agent-tool configuration without committing credentials.
- Integrate project-local AI tooling through flake development environments.

### Development environments

- Add reusable language-specific flake modules or templates.
- Standardize formatter, language-server, test, and hook workflows.
- Keep project dependencies inside development shells rather than the global
  user profile.

## Ongoing quality

- Keep rebuilds reproducible and changes reviewable.
- Add automated flake checks when a remote repository or CI is introduced.
- Extend the host/user structure only when a second machine or user requires it.

## Project boundaries

- Impermanence is intentionally out of scope; system and home data use the
  conventional persistent filesystem layout.
