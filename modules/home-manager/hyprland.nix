# Hyprland desktop: window manager, Quickshell status bar, rofi launcher
{ config, lib, pkgs, osConfig, ... }:
let
  # hepidoptera gets a layout and lid handling for its built-in panel and
  # occasional external monitors.
  isLaptop = osConfig.networking.hostName == "hepidoptera";

  workspaceCount = 6;
  workspaceNumbers = lib.range 1 workspaceCount;
  desktopWorkspaceRules = map
    (workspace:
      let
        monitor = if lib.mod workspace 2 == 1 then "DP-1" else "DP-2";
      in
      "${toString workspace}, monitor:${monitor}")
    workspaceNumbers;

  hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
  jq = lib.getExe pkgs.jq;

  toggleAnimations = pkgs.writeShellApplication {
    name = "hyprland-toggle-animations";
    runtimeInputs = [ pkgs.hyprland pkgs.jq pkgs.libnotify ];
    text = ''
      next=$(hyprctl -j getoption animations:enabled | jq -er '
        if .int == 1 then 0
        elif .int == 0 then 1
        else error("Unexpected animation state") end
      ')
      hyprctl keyword animations:enabled "$next" > /dev/null
      if [ "$next" = 1 ]; then
        state=on
      else
        state=off
      fi
      notify-send -a Hyprland -t 1500 "Hyprland animations: $state"
    '';
  };

  laptopWorkspaceLayout = pkgs.writeShellScript "hyprland-workspace-layout" ''
    exec ${lib.getExe pkgs.python3} ${../../scripts/hyprland-workspaces.py} \
      ${hyprctl} ${toString workspaceCount}
  '';

  selectWorkspacePair = pkgs.writeShellScript "hyprland-workspace-pair" ''
    exec ${lib.getExe pkgs.python3} ${../../scripts/hyprland-workspaces.py} \
      ${hyprctl} ${toString workspaceCount} --pair "$1"
  '';

  closeLaptopLid = pkgs.writeShellScript "hyprland-close-laptop-lid" ''
    if ${hyprctl} -j monitors \
      | ${jq} -e 'any(.[]; .name != "eDP-1")' > /dev/null; then
      ${hyprctl} keyword monitor "eDP-1, disable"
    fi
  '';

  openLaptopLid = pkgs.writeShellScript "hyprland-open-laptop-lid" ''
    ${hyprctl} keyword monitor "eDP-1, preferred, auto, 1"
  '';

  inherit (config.lib.formats.rasi) mkLiteral;
  inherit (config.colorScheme) palette;
  inherit (config.desktopTheme) fonts;

  quickshellWithMultimedia = pkgs.symlinkJoin {
    name = "quickshell-with-multimedia";
    paths = [ pkgs.quickshell ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/quickshell \
        --prefix QML2_IMPORT_PATH : ${pkgs.qt6.qtmultimedia}/lib/qt-6/qml \
        --prefix QT_PLUGIN_PATH : ${pkgs.qt6.qtmultimedia}/lib/qt-6/plugins
    '';
  };

  lockScreenConfig = pkgs.writeText "quickshell-lock.qml" (import ./quickshell-lock.nix {
    inherit palette;
    fontFamily = fonts.monospace.family;
  });

  # Videos live outside the store (see xdg.dataFile."animated-wallpapers" in
  # home.nix); with none present the lock screen falls back to a plain colour.
  lockScreen = pkgs.writeShellScript "lock-screen" ''
    dir="${config.xdg.dataHome}/animated-wallpapers"
    LOCK_VIDEO=$(${lib.getExe' pkgs.findutils "find"} -L "$dir" -maxdepth 1 -type f \
      \( -name '*.mp4' -o -name '*.webm' -o -name '*.mkv' \) 2>/dev/null \
      | ${lib.getExe' pkgs.coreutils "shuf"} -n 1)
    export LOCK_VIDEO
    exec ${quickshellWithMultimedia}/bin/quickshell \
      --no-duplicate \
      --path ${lockScreenConfig}
  '';
in
{

  home.packages = with pkgs; [
    toggleAnimations
    libnotify
    mpvpaper
    cava
    grim
    hyprpicker
    iotas
    networkmanagerapplet
    slurp
    swaynotificationcenter
    pavucontrol
    quickshell
    wl-clipboard
  ];

  workstation.actions.hyprland-animations = {
    label = "Toggle Hyprland animations";
    category = "Desktop";
    description = "Switch window and workspace animations on or off until config reload";
    argv = [ (lib.getExe toggleAnimations) ];
    shortcut = "Super+Shift+A";
  };

  # Status bar (replaces waybar); started by exec-once, restart with $mod SHIFT Q.
  home.file.".config/quickshell/shell.qml".text = import ./quickshell-bar.nix {
    inherit lib pkgs palette workspaceCount;
    fontFamily = fonts.monospace.family;
    reducedMotion = config.workstation.reducedMotion;
  };

  # Wallpaper daemon as a user service, bound to graphical-session.target.
  services.awww.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "hyprlang";

    extraConfig = ''
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
    '';

    settings = {

      input = {
        kb_layout = "us,de";
        kb_variant = ",qwerty";
        # Alt+Shift uses XKB directly; Super+Alt+K and the bar indicator
        # below switch every connected keyboard together.
        kb_options = "caps:escape,grp:alt_shift_toggle";
      };

      exec-once = [
        "quickshell --no-duplicate"
        "swaync"
        "DESKTOP_THEME_SILENT=1 ${config.desktopTheme.commands.applyAppearance}"
        "DESKTOP_THEME_SILENT=1 ${config.desktopTheme.commands.applyWallpaper}"
      ] ++ lib.optional isLaptop "${laptopWorkspaceLayout}";

      misc = {
        enable_swallow = true;
      };

      xwayland = { };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(${palette.base0E})";
        "col.inactive_border" = "rgb(${palette.base02})";
      };

      decoration = {
        rounding = 10;
        inactive_opacity = 1.00;
        active_opacity = 1.00;
        fullscreen_opacity = 1.00;
        # drop_shadow = false;
        # shadow_offset = "0 5";
        # "col.shadow" = "rgba(00000099)";
        blur = {
          enabled = true;
          size = 5;
          ignore_opacity = true;
          brightness = 1.0;
          contrast = 1.0;
          xray = true;
        };
      };

      animations = {
        enabled = !config.workstation.reducedMotion;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      monitor =
        if isLaptop then [
          "eDP-1, preferred, auto, 1"
          # any other output (e.g. a dock/HDMI monitor) extends to the left
          ", preferred, auto-left, auto"
        ] else [
          "DP-2, 1920x1080, 1920x0, 1"
          "DP-1, 1920x1080, 0x0, 1"
        ];

      windowrule = [
        # "float, class:anki"
        # "workspace, 1, silent, kitty"
        # Discord
        # Thunderbird
        # "workspace, 2, silent, thunderbird"
        # Firefox
        #
      ];

      "$mod" = "SUPER";

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      # Keep the built-in panel enabled if it is the only active display. With
      # an external display active, closing the lid disables the panel and
      # opening the lid restores it.
      bindl = lib.optionals isLaptop [
        ", switch:on:Lid Switch, exec, ${closeLaptopLid}"
        ", switch:off:Lid Switch, exec, ${openLaptopLid}"
      ];

      # The laptop assigns workspaces dynamically as dock displays come and go.
      workspace = if isLaptop then [ ] else desktopWorkspaceRules;

      bind = [
        "$mod, Return, exec, ghostty"
        "$mod, M, exit,"
        "$mod, F, exec, firefox"
        "$mod, N, exec, iotas"
        "$mod, S, exec, rofi -show drun -show-icons"
        "$mod, SPACE, exec, workstation-menu"
        "$mod, F1, exec, config-help"
        "$mod SHIFT, T, exec, ${config.desktopTheme.commands.picker}"
        "$mod ALT, K, exec, ${hyprctl} switchxkblayout all next"
        "$mod SHIFT, Q, exec, quickshell kill; quickshell -d --no-duplicate"
        "$mod, G, togglegroup"
        "$mod, X, killactive"
        "$mod, A, fullscreen"
        "$mod SHIFT, A, exec, ${lib.getExe toggleAnimations}"
        ''$mod SHIFT, S, exec, grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Region copied to clipboard"''
        ''$mod SHIFT, F, exec, grim - | wl-copy && notify-send "Screenshot" "Screen copied to clipboard"''
        "$mod SHIFT, L, exec, ${lockScreen}"
        # "$mod SHIFT, N, changegroupactive, f"
        # "$mod SHIFT, P, changegroupactive, b"
        # "$mod, R, togglesplit,"
        # "$mod, T, togglefloating,"
        # "$mod, P, pseudo,"
        # "$mod ALT, ,resizeactive,"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
      ]
      ++ (
        # Super switches workspace; Shift moves the focused window there.
        builtins.concatLists (map
          (
            workspace:
            let
              ws = toString workspace;
            in
            [
              "$mod, ${ws}, workspace, ${ws}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
            ]
          )
          workspaceNumbers)
      )
      ++ map (pair:
        "$mod ALT, ${toString pair}, exec, ${selectWorkspacePair} ${toString pair}")
        (lib.range 1 (workspaceCount / 2));
    };

  };

  programs.rofi = {
    enable = true;
    # `rofi-wayland` was merged back into `rofi`, which now speaks both.
    package = pkgs.rofi;
    font = "${fonts.monospace.family} 12";
    terminal = lib.getExe pkgs.ghostty;
    location = "center";

    extraConfig = {
      show-icons = true;
      display-drun = "Launch:";
      drun-display-format = "{name}";
    };

    theme = {
      "*" = {
        background-color = mkLiteral "#${palette.base00}";
        text-color = mkLiteral "#${palette.base05}";
      };

      window = {
        width = mkLiteral "35%";
        transparency = "real";
        orientation = mkLiteral "vertical";
        border = mkLiteral "2px";
        border-color = mkLiteral "#${palette.base0E}";
        border-radius = mkLiteral "10px";
      };

      mainbox.children = map mkLiteral [ "inputbar" "listview" ];

      listview = {
        columns = 2;
        lines = 9;
        padding = mkLiteral "8px 0px";
        fixed-height = true;
        fixed-columns = true;
        fixed-lines = true;
        border = mkLiteral "0px 10px 6px 10px";
      };

      element = {
        padding = mkLiteral "4px 12px";
        text-color = mkLiteral "#${palette.base05}";
        border-radius = mkLiteral "5px";
      };

      "element selected" = {
        text-color = mkLiteral "#${palette.base01}";
        background-color = mkLiteral "#${palette.base0B}";
      };

      element-text = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      element-icon = {
        size = mkLiteral "16px";
        background-color = mkLiteral "inherit";
        padding = mkLiteral "0px 6px 0px 0px";
        alignment = mkLiteral "vertical";
      };

      inputbar = {
        padding = mkLiteral "10px 0px 0px";
        children = map mkLiteral [ "prompt" "entry" ];
      };

      prompt = {
        text-color = mkLiteral "#${palette.base0D}";
        padding = mkLiteral "10px 6px 0px 10px";
      };

      entry = {
        text-color = mkLiteral "#${palette.base05}";
        padding = mkLiteral "10px 10px 0px 0px";
      };
    };
  };

  xdg.configFile."swaync/style.css".text = ''
    * {
      font-family: "${fonts.ui.family}";
      font-size: ${toString fonts.ui.size}pt;
      ${lib.optionalString config.workstation.reducedMotion "transition-duration: 0s;"}
    }
    .control-center, .notification {
      background: #${palette.base00};
      color: #${palette.base05};
      border: 2px solid #${palette.base0E};
      border-radius: 10px;
    }
    .notification-content { background: transparent; }
    .summary { color: #${palette.base05}; }
    .body, .time { color: #${palette.base04}; }
    .notification-action, .close-button, .widget-buttons-grid > flowbox > flowboxchild > button {
      background: #${palette.base02};
      color: #${palette.base05};
      border-radius: 5px;
    }
    .notification-action:hover, .close-button:hover {
      background: #${palette.base0E};
      color: #${palette.base00};
    }
  '';

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = [{
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];

      input-field = [{
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        outer_color = "rgba(${palette.base0E}ff)";
        inner_color = "rgba(${palette.base00}ee)";
        font_color = "rgba(${palette.base05}ff)";
        fade_on_empty = false;
        placeholder_text = "Password...";
        position = "0, -40";
        halign = "center";
        valign = "center";
      }];

      label = [{
        monitor = "";
        text = ''cmd[update:1000] echo "$(date +'%H:%M')"'';
        color = "rgba(${palette.base05}ff)";
        font_size = 90;
        font_family = fonts.monospace.family;
        position = "0, 200";
        halign = "center";
        valign = "center";
      }];
    };
  };

  # Locks the session after idle, then blanks the displays shortly after.
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "${lockScreen}";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 1200;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Plasma registers application shortcuts from desktop entries. Hyprland has
  # the matching binding above, so Super+S opens the same launcher in either
  # desktop session.
  xdg.dataFile."applications/rofi.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Rofi
    GenericName=Application Launcher
    Exec=${lib.getExe pkgs.rofi} -show drun -show-icons
    Icon=system-search
    Terminal=false
    Categories=Utility;
    X-KDE-Shortcuts=Meta+S
  '';
}
