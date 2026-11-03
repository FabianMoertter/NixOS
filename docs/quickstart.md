# Workstation quickstart

Press `Super+Space` for actions and `Super+F1` for personal help. `Super` is
the Windows/Meta key. These bindings apply in Hyprland.

| Task | Command or shortcut |
| --- | --- |
| Terminal | `Super+Return` |
| Applications | `Super+S` |
| Project picker | `project` or Actions → Development |
| Learning session | `study start japanese` or Actions → Learning |
| Documentation | `config-help` |
| Active learning mode | `study status` |
| Theme and wallpaper | `Super+Shift+T` |

## Apply changes

From the checkout, evaluate and build the intended host before switching:

```sh
nix flake check --no-build
sudo nixos-rebuild build --flake .#hepidoptera
sudo nixos-rebuild switch --flake .#hepidoptera
```

Use `lepidoptera` on the desktop. Home Manager is included in this rebuild.
Log out and back into Hyprland after changing session services or input methods.
The `update` and legacy `hm-update` aliases both rebuild the current hostname
from your configured checkout.

## Recover

Keep a working generation in the boot menu. To undo the last system switch:

```sh
sudo nixos-rebuild switch --rollback
```

If the graphical session fails, use `Ctrl+Alt+F3` to log into a console and run
the rollback there. GNOME on the desktop and Plasma on the laptop remain
available from the display manager.

## Personal paths

Each user's Home Manager configuration can override:

```nix
workstation = {
  repoDirectory = "${config.home.homeDirectory}/Projects/NixOS";
  projectsDirectory = "${config.home.homeDirectory}/Projects";
  studyDirectory = "${config.home.homeDirectory}/Documents/Learning";
  reducedMotion = true;
};
```

The `fabian` account retains its existing nested `Projects/NixOS/nixos-config`
checkout. Neovim and animated wallpapers use this same repository path.
