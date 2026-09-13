# nixos-config: Nix-Flake for my systems

Repo under construction!

# Systems

| Hostname | Machine | Status
| :--- | :--- | :---
| lepidoptera | Desktop | active

# Overview
| Program           | Name      |
| :---              | :---      |
| Code Editor       | Neovim         |
| Shell             | zsh            |
| Terminal Emulator | kitty/ghostty  |
| Desktop           | GNOME/Hyprland |
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
