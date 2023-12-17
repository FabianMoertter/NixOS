# nixos-config: Nix-Flake for my systems

Repo under construction!

# Systems

| Hostname | Machine | Status
| :--- | :--- | :---
| lepidoptera | Desktop          | WIP
| mantodea    | Mini Desktop     | WIP
| coleoptera  | Laptop 1         | not started
| hymenoptera | Laptop 2         | WIP
|             | Raspberry Pi     | not started

# Overview
| Program                              | Name                                                                                                                           |
| :---                                 | :---                                                                                                                           |
| Code Editor                          | Neovim|
| Shell                                | zsh/bash |
| Terminal Emulator                    | alacritty |

# Installation
**Warning: Do not follow this blindly, it will probably not work for you!**

## NixOS

After installing NixOS on your system, run:
```
nix --extra-experimental-features nix-command --extra-experimental-features flakes run nixpkgs#git clone https://github.com/FabianMoertter/NixOS
cd NixOS
nix-shell
```
to clone this repo and bootstrap flakes and home-manager. **Note**: The shell provides neovim so you can
edit configuration files.
**Copy hardware-configuration.nix**: Depending on what you do you need to copy your `hardware-configuration.nix`
from `/etc/nixos/` to the desired location. Do not just copy this command!
```
cp /etc/nixos/hardware-configuration.nix system/<system>/hardware-configuration.nix
```
Now you can build the system:
```
sudo nixos-rebuild switch --flake .#<hostname>
```

## Home Manager
Proceed with this steps after you installed NixOS and after you rebuild the system. You should
still be in the dev shell from above. Otherwise, try:
```
nix shell nixpkgs#home-manager
```
Then run home-manager with:
```
home-manager switch --flake .
```
If you get an error like this:
"Could not find suitable profile directory, tried .../profiles and .../user"
run:
```
nix profile list
```
to fix the issue and then run home-manager again.

# Neovim

Neovim config is based on kickstart.nvim: https://github.com/nvim-lua/kickstart.nvim

The config is located under `modules/home-manager/nvim/`

# TODO/Projects
* move shells to flakes
* modularize flake
* install: virtualbox ... 
* docs (and links to them)
* nix flake for neovim
* mini as home-server
* configure impermanence
* disable system going to sleep
* SOPS nix for secrets
* add a windowmanager

# Credits

Flake based on standard template: https://github.com/Misterio77/nix-starter-configs.

# Nix Resources

Here is an incomplete list of great Nix/NixOS resources:

Documentation:
* https://nix.dev
* https://nixos.org/manual/nix/stable/introduction

NixOS repositories:
* https://github.com/jakehamilton/config

Videos:

Neovim repositories:
* https://github.com/jakehamilton/neovim
* https://github.com/jordanisaacs/neovim-flake
* https://github.com/mrcjkb/kickstart-nix.nvim

sops-nix:
* https://github.com/Mic92/sops-nix

Blogs and articles:
* https://primamateria.github.io/blog/neovim-nix
