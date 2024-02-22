# nixos-config: Nix-Flake for my systems

Repo under construction!

# Systems

| Hostname | Machine | Status
| :--- | :--- | :---
| lepidoptera | Desktop          | WIP
| mantodea    | [Mini Homelab](<./docs/home-server.md>)     | WIP
| coleoptera  | Laptop 1	 | not started
| hymenoptera | Laptop 2         | WIP
|             | Raspberry Pi     | not started

# Overview
| Program           | Name      |
| :---              | :---      |
| Code Editor       | Neovim    |
| Shell             | zsh/bash  |
| Terminal Emulator | alacritty |

# Project Structure
    .
    ├── systems            # System configuration
    ├── home-manager       # Home configuration
    ├── docs               # Documentation files
    ├── modules            # Modules for system and home configuration
    ├── shells             # Development shells (independent of this NixOS configuration)
    ├── ...
    ├── LICENSE
    ├── flake.nix
    ├── flake.lock
    ├── shell.nix
    └── README.md

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
home-manager switch --flake .#<user>@<hostname>
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

# [Projects](<./docs/projects.md>)

# Documentation

## [General-nix](<./docs/general_nix.md#Nix Commands>)
## [Functions](./docs/general_nix.md#Functions)

# Nix Resources

Here is an incomplete list of great Nix/Nixpkgs/NixOS resources:

**Documentation:**
* https://nix.dev
* https://nixos.org/manual/nix/stable/introduction
* https://nixos.wiki/wiki/Flakes

**Tutorials:**
* https://zero-to-nix.com/
* https://github.com/brainrake/nixos-tutorial

**NixOS example repositories:**
* https://github.com/jakehamilton/config
* https://github.com/sioodmy/dotfiles/tree/main
* https://github.com/tars0x9752/home
* https://github.com/misterio77/nix-config
* https://github.com/librephoenix/nixos-config
* https://github.com/HeinzDev/Hyprland-dotfiles 
* https://gitlab.com/Zaney/zaneyos
  * for Hyprland config
* https://github.com/sweenu/nixfiles
* https://github.com/Raagh/dotfiles
* https://github.com/terlar/nix-config
* https://github.com/colemickens/nixcfg
* https://github.com/IogaMaster/dotfiles
* https://github.com/hlissner/dotfiles
* https://github.com/redyf/nixdots
* https://github.com/rxyhn/yuki/tree/main
* https://github.com/LongerHV/nixos-configuration

**Homelab examples:**
* https://github.com/badele/nix-homelab
* https://github.com/TUM-DSE/doctor-cluster-config 

**Videos:**
* https://www.youtube.com/@vimjoyer

**Neovim repositories:**
* https://github.com/jakehamilton/neovim
* https://github.com/jordanisaacs/neovim-flake
* https://github.com/mrcjkb/kickstart-nix.nvim

**sops-nix:**
* https://github.com/Mic92/sops-nix

**deploy-rs:**
* https://github.com/serokell/deploy-rs

**Blogs and articles:**
* https://primamateria.github.io/blog/neovim-nix
* https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes#nix-flakes-and-classic-nix

**Companies:**
* https://determinate.systems 
* https://www.tweag.io/

**Other:**
* https://flakehub.com/flakes

# Credits

Flake based on standard template: https://github.com/Misterio77/nix-starter-configs.

[Neovim](Neovim) config based on kickstart.nvim: https://github.com/nvim-lua/kickstart.nvim.

Hyprland config inspired by: https://gitlab.com/stephan-raabe/dotfiles

Wallpaper: [DNA](https://www.freepik.com/free-photo/dna-strand_1036396.htm#query=dna%20wallpaper&position=30&from_view=keyword&track=ais&uuid=64828555-133e-4b5d-ab70-0dd1e7ceb070) Image by kjpargeter on Freepik
