# Hyprland cheatsheet

`Super` means the Windows/Meta key. Commands here describe this configuration.

| Shortcut | Action |
| --- | --- |
| Super+Return | Ghostty |
| Super+S | Applications |
| Super+Space | Actions, projects, utilities and learning |
| Super+F1 | Documentation picker |
| Super+F | Firefox |
| Super+N | Iotas notes |
| Super+H/J/K/L or arrows | Focus window |
| Super+1…6 | Workspace 1…6 |
| Super+Shift+1…6 | Move window to workspace |
| Super+X | Close active window |
| Super+A | Toggle fullscreen |
| Super+Shift+A | Toggle Hyprland animations |
| Super+G | Toggle window group |
| Super+left mouse drag | Move window |
| Super+right mouse drag | Resize window |
| Super+Shift+S | Select screenshot region to clipboard |
| Super+Shift+F | Full screenshot to clipboard |
| Super+Shift+T | Theme and wallpaper picker |
| Super+Alt+K | Switch keyboard layout on all keyboards |
| Super+Shift+L | Lock |
| Super+Shift+Q | Restart Quickshell bar |
| Super+M | Exit Hyprland |

There are six workspaces: 1, 3, 5 on the left display and 2, 4, 6 on
the right. The desktop uses DP-1 (left) and DP-2 (right). The laptop assigns
workspaces by display position when docking, preferring the external pair when
two external monitors are connected. Undocked, all six use the laptop panel.
Clipboard history is available through
Actions → Utilities; entries remain until cleared with `cliphist wipe`.

Toggle window and workspace animations with `Super+Shift+A`,
Actions → Desktop → Toggle Hyprland animations, or `hyprland-toggle-animations`.
A notification shows whether animations are on or off. A config reload or new
session restores the default set by `workstation.reducedMotion`.
