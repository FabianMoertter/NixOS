# nixos-config: Nix-Flake for my systems

Personal Hyprland workstation with Ghostty, Zsh, tmux, Neovim, development
shell templates, and learning sessions.

- [Quickstart and recovery](docs/quickstart.md)
- [Development shells and templates](docs/development.md)
- [Learning modes and Japanese setup](docs/learning.md)
- [Architecture and customization](docs/architecture.md)
- Cheatsheets: [Hyprland](docs/cheatsheets/hyprland.md),
  [terminal](docs/cheatsheets/terminal.md), [Neovim](docs/cheatsheets/nvim.md),
  [learning](docs/cheatsheets/learning.md)

In Hyprland, press **Super+Space** for actions and **Super+F1** for searchable
personal help. `project` opens a project session; `project new` initializes a
development template. `study start japanese` starts a learning session.

# Systems

| Hostname | Machine | Status
| :--- | :--- | :---
| lepidoptera | Desktop (`fabian`) | active
| hepidoptera | Laptop (`fm`) | active

# Overview
| Program           | Name      |
| :---              | :---      |
| Code Editor       | Neovim         |
| Shell             | zsh            |
| Terminal Emulator | Ghostty (Kitty also available) |
| Desktop           | Hyprland + Quickshell; GNOME/Plasma fallback |
| nixpkgs           | nixos-26.05    |

# Project Structure
    .
    ├── systems
    │   └── desktop            # lepidoptera: configuration.nix + hardware-configuration.nix
    ├── home-manager
    │   └── fabian             # home.nix
    ├── modules
    │   ├── system             # NixOS modules, imported by systems/desktop/configuration.nix
    │   └── home-manager       # home-manager modules, imported by home-manager/fabian/home.nix
    ├── templates              # minimal, nix, python, go, rust, node devshells
    ├── scripts                # shared command palette and project helper
    ├── docs                   # usage, architecture, cheatsheets
    ├── assets                 # wallpapers
    ├── LICENSE
    ├── flake.nix
    ├── flake.lock
    └── README.md

Modules are wired up with plain `imports = [ ./path.nix ]`; there is no module registry to
keep in sync.

# Installation
**Warning: Do not follow this blindly, it will probably not work for you!**

## NixOS

After installing NixOS on your system, run:
```
nix --extra-experimental-features 'nix-command flakes' run nixpkgs#git -- clone https://github.com/FabianMoertter/NixOS
cd NixOS
```
**Copy hardware-configuration.nix**: Depending on what you do you need to copy your `hardware-configuration.nix`
from `/etc/nixos/` to the desired location. Do not just copy this command!
```
cp /etc/nixos/hardware-configuration.nix systems/desktop/hardware-configuration.nix
```
Now you can build the system:
```
sudo nixos-rebuild switch --flake .#<hostname>
```

## Home Manager
Home Manager runs as a NixOS module, so `nixos-rebuild switch` applies the home configuration
too. There is no separate `home-manager switch` step.

# Neovim

Neovim config is based on kickstart.nvim: https://github.com/nvim-lua/kickstart.nvim

The config is located under `nvim/` and is symlinked to
`~/.config/nvim` out of the Nix store, so edits take effect without a rebuild.

# Nix Resources

Here is an incomplete list of great Nix/Nixpkgs/NixOS resources:

**Documentation:**
* https://nix.dev
* https://nixos.org/manual/nix/stable/introduction
* https://nixos.wiki/wiki/Flakes

**Tutorials:**
* https://zero-to-nix.com/
* https://github.com/brainrake/nixos-tutorial

# Credits

Flake based on standard template: https://github.com/Misterio77/nix-starter-configs.

[Neovim](nvim) config based on kickstart.nvim: https://github.com/nvim-lua/kickstart.nvim.

Hyprland config inspired by: https://gitlab.com/stephan-raabe/dotfiles

Wallpaper: [DNA](https://www.freepik.com/free-photo/dna-strand_1036396.htm#query=dna%20wallpaper&position=30&from_view=keyword&track=ais&uuid=64828555-133e-4b5d-ab70-0dd1e7ceb070) Image by kjpargeter on Freepik
