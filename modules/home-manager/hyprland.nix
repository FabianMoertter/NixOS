# Hyprland desktop: window manager, Quickshell status bar, rofi launcher
{ config, lib, pkgs, osConfig, ... }:
let
  awww = lib.getExe pkgs.awww;

  # hepidoptera gets a layout and lid handling for its built-in panel and
  # occasional external monitors.
  isLaptop = osConfig.networking.hostName == "hepidoptera";

  workspaceCount = 10;
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

  closeLaptopLid = pkgs.writeShellScript "hyprland-close-laptop-lid" ''
    if ${hyprctl} -j monitors \
      | ${jq} -e 'any(.[]; .name != "eDP-1")' > /dev/null; then
      ${hyprctl} keyword monitor "eDP-1, disable"
    fi
  '';

  openLaptopLid = pkgs.writeShellScript "hyprland-open-laptop-lid" ''
    ${hyprctl} keyword monitor "eDP-1, preferred, auto, 1"
  '';

  wallpaperCmds =
    if isLaptop then
      "${awww} img ${../../assets/wallpaper/dna-strand.jpg}"
    else ''
      ${awww} img --outputs DP-1 ${../../assets/wallpaper/dna-strand-right.jpg}
      ${awww} img --outputs DP-2 ${../../assets/wallpaper/dna-strand-left.jpg}'';

  # awww-daemon is started by services.awww, but systemd gives us no ordering
  # guarantee against Hyprland's exec-once, so wait for its socket first.
  setWallpaper = pkgs.writeShellScript "set-wallpaper" ''
    tries=0
    until ${awww} query > /dev/null 2>&1 || [ "$tries" -ge 50 ]; do
      tries=$((tries + 1))
      ${lib.getExe' pkgs.coreutils "sleep"} 0.2
    done
    ${wallpaperCmds}
  '';

  inherit (config.lib.formats.rasi) mkLiteral;
  inherit (config.colorScheme) palette;

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
    libnotify
    mpvpaper
    cava
    font-awesome
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

  # Status bar (replaces waybar); started by exec-once, restart with $mod SHIFT Q.
  home.file.".config/quickshell/shell.qml".text = import ./quickshell-bar.nix {
    inherit lib pkgs palette;
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
        "${setWallpaper}"
      ];

      misc = {
        enable_swallow = true;
      };

      xwayland = { };

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
        enabled = "yes";
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

      # fixed per-monitor workspace layout only makes sense on the desktop's
      # static dual-monitor setup; the laptop lets workspaces roam freely.
      workspace = if isLaptop then [ ] else desktopWorkspaceRules;

      bind = [
        "$mod, Return, exec, ghostty"
        "$mod, M, exit,"
        "$mod, F, exec, firefox"
        "$mod, N, exec, iotas"
        "$mod, S, exec, rofi -show drun -show-icons"
        "$mod ALT, K, exec, ${hyprctl} switchxkblayout all next"
        "$mod SHIFT, Q, exec, quickshell kill; quickshell -d --no-duplicate"
        "$mod, G, togglegroup"
        "$mod, X, killactive"
        "$mod, A, fullscreen"
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
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList
          (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          workspaceCount)
      );
    };

  };

  programs.rofi = {
    enable = true;
    # `rofi-wayland` was merged back into `rofi`, which now speaks both.
    package = pkgs.rofi;
    font = "JetBrainsMono Nerd Font 12";
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
        border-color = mkLiteral "#${palette.base0B}";
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
        font_family = "JetBrainsMono Nerd Font";
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
