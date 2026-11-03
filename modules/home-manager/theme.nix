{ config, inputs, lib, osConfig, pkgs, ... }:
let
  cfg = config.desktopTheme;
  isLaptop = osConfig.networking.hostName == "hepidoptera";
  stateDir = "\${XDG_STATE_HOME:-$HOME/.local/state}/desktop-theme";
  managedWallpapers = "${config.xdg.dataHome}/wallpapers/nixos";
  wallpaperTransition = if config.workstation.reducedMotion then "none" else "fade";

  applyAppearance = pkgs.writeShellApplication {
    name = "desktop-theme-apply";
    runtimeInputs = with pkgs; [ coreutils glib libnotify ];
    text = ''
      state_dir="${stateDir}"
      mkdir -p "$state_dir"

      mode="''${1:-}"
      if [[ -z "$mode" && -r "$state_dir/appearance" ]]; then
        mode=$(<"$state_dir/appearance")
      fi
      mode="''${mode:-${cfg.defaultAppearance}}"

      case "$mode" in
        dark)
          color_scheme="prefer-dark"
          gtk_theme="adw-gtk3-dark"
          icon_theme="Papirus-Dark"
          ;;
        light)
          color_scheme="prefer-light"
          gtk_theme="adw-gtk3"
          icon_theme="Papirus"
          ;;
        *)
          echo "Unknown appearance: $mode" >&2
          exit 2
          ;;
      esac

      printf '%s\n' "$mode" > "$state_dir/appearance"
      gsettings set org.gnome.desktop.interface color-scheme "$color_scheme"
      gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
      gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"

      if [[ "''${DESKTOP_THEME_SILENT:-0}" != 1 ]]; then
        notify-send "Desktop theme" "Using the $mode appearance"
      fi
    '';
  };

  applyWallpaper = pkgs.writeShellApplication {
    name = "desktop-wallpaper-apply";
    runtimeInputs = with pkgs; [ awww coreutils libnotify ];
    text = ''
      state_dir="${stateDir}"
      mkdir -p "$state_dir"

      wallpaper="''${1:-}"
      if [[ -z "$wallpaper" && -r "$state_dir/wallpaper" ]]; then
        wallpaper=$(<"$state_dir/wallpaper")
      fi
      wallpaper="''${wallpaper:-dna}"

      tries=0
      until awww query >/dev/null 2>&1 || [[ "$tries" -ge 50 ]]; do
        tries=$((tries + 1))
        sleep 0.2
      done

      if [[ "$wallpaper" == dna ]]; then
        ${if isLaptop then ''
          awww img "${managedWallpapers}/dna-strand.jpg" --transition-type ${wallpaperTransition}
        '' else ''
          awww img --outputs DP-1 "${managedWallpapers}/dna-strand-right.jpg" --transition-type ${wallpaperTransition}
          awww img --outputs DP-2 "${managedWallpapers}/dna-strand-left.jpg" --transition-type ${wallpaperTransition}
        ''}
      elif [[ -f "$wallpaper" ]]; then
        awww img "$wallpaper" --transition-type ${wallpaperTransition}
      else
        notify-send -u critical "Wallpaper" "The saved image no longer exists: $wallpaper"
        exit 1
      fi

      printf '%s\n' "$wallpaper" > "$state_dir/wallpaper"
      if [[ "''${DESKTOP_THEME_SILENT:-0}" != 1 ]]; then
        notify-send "Wallpaper" "Wallpaper updated"
      fi
    '';
  };

  themePicker = pkgs.writeShellApplication {
    name = "desktop-theme-picker";
    runtimeInputs = with pkgs; [ coreutils findutils rofi ];
    text = ''
      list_wallpapers() {
        if [[ -d "${managedWallpapers}" ]]; then
          find -L "${managedWallpapers}" -maxdepth 1 -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
            ! -name 'dna-strand-left.jpg' ! -name 'dna-strand-right.jpg'
        fi
        if [[ -d "$HOME/Pictures/Wallpapers" ]]; then
          find -L "$HOME/Pictures/Wallpapers" -maxdepth 2 -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \)
        fi
      }

      pick_wallpaper() {
        local image
        image=$(
          list_wallpapers | sort -u | while IFS= read -r candidate; do
            printf '%s\0icon\x1f%s\n' "$candidate" "$candidate"
          done | rofi -dmenu -i -show-icons -p "Wallpaper"
        )
        [[ -n "$image" ]] && ${applyWallpaper}/bin/desktop-wallpaper-apply "$image"
      }

      choice=$(printf '%s\n' \
        "Appearance: Dark" \
        "Appearance: Light" \
        "Wallpaper: DNA preset" \
        "Wallpaper: Choose image" \
        "Wallpaper: Random image" \
        | rofi -dmenu -i -p "Desktop theme")

      case "$choice" in
        "Appearance: Dark")
          ${applyAppearance}/bin/desktop-theme-apply dark
          ;;
        "Appearance: Light")
          ${applyAppearance}/bin/desktop-theme-apply light
          ;;
        "Wallpaper: DNA preset")
          ${applyWallpaper}/bin/desktop-wallpaper-apply dna
          ;;
        "Wallpaper: Choose image")
          pick_wallpaper
          ;;
        "Wallpaper: Random image")
          image=$(list_wallpapers | shuf -n 1)
          [[ -n "$image" ]] && ${applyWallpaper}/bin/desktop-wallpaper-apply "$image"
          ;;
      esac
    '';
  };
in
{
  options.desktopTheme = {
    defaultAppearance = lib.mkOption {
      type = lib.types.enum [ "dark" "light" ];
      default = "dark";
      description = "Appearance used before a selection has been saved.";
    };

    fonts = {
      ui = {
        family = lib.mkOption { type = lib.types.str; default = "Inter"; };
        size = lib.mkOption { type = lib.types.int; default = 11; };
      };
      monospace = {
        family = lib.mkOption { type = lib.types.str; default = "JetBrainsMono Nerd Font"; };
        size = lib.mkOption { type = lib.types.int; default = 14; };
      };
    };

    commands = {
      applyAppearance = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "${applyAppearance}/bin/desktop-theme-apply";
      };
      applyWallpaper = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "${applyWallpaper}/bin/desktop-wallpaper-apply";
      };
      picker = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "${themePicker}/bin/desktop-theme-picker";
      };
    };
  };

  config = {
    colorScheme = inputs.nix-colors.colorSchemes.catppuccin-frappe;

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      adw-gtk3
      applyAppearance
      applyWallpaper
      bibata-cursors
      font-awesome
      inter
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
      papirus-icon-theme
      themePicker
    ];

    gtk = {
      enable = true;
      colorScheme = cfg.defaultAppearance;
      font = {
        name = cfg.fonts.ui.family;
        size = cfg.fonts.ui.size;
      };
      theme = {
        package = pkgs.adw-gtk3;
        name = if cfg.defaultAppearance == "dark" then "adw-gtk3-dark" else "adw-gtk3";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      # Libadwaita apps should follow color-scheme instead of importing a
      # fixed GTK 4 stylesheet, otherwise the runtime picker cannot switch.
      gtk4.theme = null;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    xdg.dataFile."wallpapers/nixos".source = ../../assets/wallpaper;

    xdg.dataFile."applications/desktop-theme.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Desktop Theme
      GenericName=Appearance and Wallpaper
      Exec=${themePicker}/bin/desktop-theme-picker
      Icon=preferences-desktop-theme
      Terminal=false
      Categories=Settings;DesktopSettings;
      X-KDE-Shortcuts=Meta+Shift+T
    '';
  };
}
