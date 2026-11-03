# Desktop theme

[Back to roadmap](roadmap.md)

The shared Home Manager theme contract lives in
`modules/home-manager/theme.nix`. It defines the nix-colors palette, UI and
monospace fonts, GTK and Qt integration, icon theme, cursor, and managed
wallpapers for both workstations.

## Theme picker

Press `Super+Shift+T` in Hyprland or launch **Desktop Theme** from an
application launcher. The picker can:

- switch between the explicit dark and light appearance variants;
- apply the DNA wallpaper preset, including its matched desktop-monitor pair;
- choose an image from the repository-managed wallpaper set or
  `~/Pictures/Wallpapers`; or
- select a random image from those locations.

The appearance choice updates GTK and libadwaita applications immediately.
Ghostty, tmux, Neovim, Rofi, Quickshell, Hyprland borders, and notifications
retain the declarative Catppuccin Frappe palette in either mode.
Qt uses the GTK platform integration so new Qt applications use the same
appearance. Some already-running applications may need to be restarted.

Selections are stored below `~/.local/state/desktop-theme` and reapplied when
Hyprland starts. The declarative default is dark with the DNA wallpaper.

The same operations are available from the command line:

```console
desktop-theme-picker
desktop-theme-apply dark
desktop-theme-apply light
desktop-wallpaper-apply dna
desktop-wallpaper-apply /path/to/image.jpg
```

To add personal wallpapers without changing this repository, put JPEG, PNG,
or WebP files in `~/Pictures/Wallpapers`.

Set `workstation.reducedMotion = true` in your Home Manager configuration to
disable the configured window/widget animations and cursor blink and apply
wallpapers without animated transitions.
