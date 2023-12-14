# nixos-config: Nix-Flake for my systems

Repo under construction!

# Nix Commands

Rebuild system
```
sudo nixos-rebuild switch --flake .#
```

Rebuild home-manager
```
home-manager switch --flake .
```

List generations
```
nix-env --list-generations
```

List all generations
```
nix profile history --profile /nix/var/nix/profiles/system
```

Update channel
```
nix flake update
```

Delete generations
```
sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 14d
```

# TODO/Projects
* move shells to flakes
* modularize flake
* neovim config with home-manager
* install: virtualbox ... 
* docs
* nix flake for neovim
* mini as home-server
* configure impermanence
* disable system going to sleep

# Overview
| Program                              | Name                                                                                                                           |
| :---                                 | :---                                                                                                                           |
| Code Editor                          | Neovim|
| Shell                                | zsh|
| Terminal Emulator                    | alacritty |

# Installation

Start home-manager
```
nix shell nixpkgs#home-manager
```

# Systems

| Hostname | Machine | Status
| :--- | :--- | :---
| lepidoptera | Desktop          | WIP
| mantodea    | Mini Desktop     | WIP
| coleoptera  | Laptop 1         | not started
| hymenoptera | Laptop 2         | WIP
|             | Raspberry Pi     | not started

# Credits

Flake based on standard template: https://github.com/Misterio77/nix-starter-configs.

