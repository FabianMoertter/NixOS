# Hyprland desktop: window manager, waybar status bar, rofi launcher,
# and an experimental Quickshell bar (toggle with $mod SHIFT Q)
{ config, lib, pkgs, ... }:
let
  awww = lib.getExe pkgs.awww;

  # awww-daemon is started by services.awww, but systemd gives us no ordering
  # guarantee against Hyprland's exec-once, so wait for its socket first.
  setWallpaper = pkgs.writeShellScript "set-wallpaper" ''
    tries=0
    until ${awww} query > /dev/null 2>&1 || [ "$tries" -ge 50 ]; do
      tries=$((tries + 1))
      ${lib.getExe' pkgs.coreutils "sleep"} 0.2
    done
    ${awww} img --outputs DP-1 ${../../assets/wallpaper/dna-strand-right.jpg}
    ${awww} img --outputs DP-2 ${../../assets/wallpaper/dna-strand-left.jpg}
  '';

  inherit (config.lib.formats.rasi) mkLiteral;
  inherit (config.colorScheme) palette;
in
{

  home.packages = with pkgs; [
    libnotify
    mpvpaper
    cava
    font-awesome
    grim
    hyprpicker
    networkmanagerapplet
    slurp
    swaynotificationcenter
    pavucontrol
    quickshell
    wl-clipboard
  ];

  # Experimental Quickshell bar, kept alongside waybar for now.
  # Toggle with $mod SHIFT Q; not started automatically.
  home.file.".config/quickshell/shell.qml".text = ''
    import Quickshell
    import Quickshell.Hyprland
    import QtQuick
    import QtQuick.Layouts

    ShellRoot {
      Variants {
        model: Quickshell.screens

        PanelWindow {
          required property var modelData
          screen: modelData

          anchors {
            top: true
            left: true
            right: true
          }

          height: 32
          color: "#${palette.base00}"

          RowLayout {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            spacing: 10

            Repeater {
              model: 8

              Text {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                text: (index + 1).toString()
                color: isActive ? "#${palette.base0E}" : "#${palette.base04}"
                font.bold: isActive
                font.pixelSize: 14

                MouseArea {
                  anchors.fill: parent
                  onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
              }
            }
          }

          Text {
            id: clockText
            anchors.centerIn: parent
            color: "#${palette.base05}"
            font.bold: true
            font.pixelSize: 14

            property date now: new Date()
            text: Qt.formatDateTime(now, "ddd dd MMM  HH:mm")

            Timer {
              interval: 1000
              running: true
              repeat: true
              onTriggered: clockText.now = new Date()
            }
          }
        }
      }
    }
  '';

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
        kb_options = "caps:escape,grp:alt_shift_toggle";
      };

      exec-once = [
        "waybar"
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

      monitor = [
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

      workspace = [
        "1, monitor:DP-1"
        "2, monitor:DP-2"
        "3, monitor:DP-1"
        "4, monitor:DP-2"
        "5, monitor:DP-1"
        "6, monitor:DP-2"
        "7, monitor:DP-1"
        "8, monitor:DP-2"
      ];

      bind = [
        "$mod, Return, exec, ghostty"
        "$mod, M, exit,"
        "$mod, F, exec, firefox"
        "$mod, S, exec, rofi -show drun -show-icons"
        "$mod SHIFT, Q, exec, pkill quickshell || quickshell"
        "$mod, G, togglegroup"
        "$mod, X, killactive"
        "$mod, A, fullscreen"
        ''$mod SHIFT, S, exec, grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Region copied to clipboard"''
        ''$mod SHIFT, F, exec, grim - | wl-copy && notify-send "Screenshot" "Screen copied to clipboard"''
        "$mod SHIFT, L, exec, pidof hyprlock || hyprlock"
        # "$mod SHIFT, N, changegroupactive, f"
        # "$mod SHIFT, P, changegroupactive, b"
        # "$mod, R, togglesplit,"
        # "$mod, T, togglefloating,"
        # "$mod, P, pseudo,"
        # "$mod ALT, ,resizeactive,"
        "$mod, 1, focusmonitor, DP-2"
        "$mod, 2, focusmonitor, DP-1"
        "$mod, 3, focusmonitor, DP-2"
        "$mod, 4, focusmonitor, DP-1"
        "$mod, 5, focusmonitor, DP-2"
        "$mod, 6, focusmonitor, DP-1"
        "$mod, 7, focusmonitor, DP-2"
        "$mod, 8, focusmonitor, DP-1"
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
          10)
      );
    };

  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [{
      layer = "top";
      position = "top";
      height = 44;
      margin-top = 8;
      margin-left = 10;
      margin-right = 10;

      modules-left = [ "hyprland/workspaces" "cava" ];
      modules-center = [ "clock" ];
      modules-right = [ "disk" "network" "pulseaudio" "bluetooth" "custom/filemanager" "custom/paperless" "tray" ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        active-only = false;
        on-click = "activate";
        format = "{name}";
        persistent-workspaces = {
          "*" = [ 1 2 3 4 5 6 7 8 ];
        };
      };

      "cava" = {
        hide_on_silence = true;
        framerate = 60;
        bars = 8;
        format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        input_delay = 1;
        sleep_timer = 5;
        bar_delimiter = 0;
      };

      "clock" = {
        format = "󰃭  {:%a %d %b  %H:%M}";
        tooltip = true;
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        format-alt = "{:%I:%M %p}";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#${config.colorScheme.palette.base0E}'><b>{}</b></span>";
            weekdays = "<span color='#${config.colorScheme.palette.base0A}'><b>{}</b></span>";
            today = "<span color='#${config.colorScheme.palette.base08}'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      "disk" = {
        interval = 600;
        format = "󰋊 {percentage_used}%";
        tooltip-format = "{used} / {total} ({percentage_used}%) on {path}";
        on-click = "kitty -e btop";
      };

      "network" = {
        format-wifi = "󰤨 {essid}";
        format-ethernet = "󰈀 {ipaddr}";
        format-disconnected = "󰤭 Offline";
        tooltip-format-wifi = "󰤨 {essid}  {signalStrength}%\n{ipaddr}/{cidr}";
        tooltip-format-ethernet = "󰈀 {ifname}\n{ipaddr}/{cidr}";
        tooltip-format-disconnected = "Disconnected";
        on-click = "wifimenu";
      };

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-bluetooth = "󰂯 {volume}%";
        format-bluetooth-muted = "󰂲 Muted";
        format-muted = "󰝟 Muted";
        format-source = "󰍬 {volume}%";
        format-source-muted = "󰍭";
        format-icons = {
          headphone = "󰋋";
          headset = "󰋎";
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "pavucontrol";
        on-scroll-up = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      };

      "bluetooth" = {
        format = "󰂯 {status}";
        format-disabled = "󰂲";
        format-off = "󰂲";
        format-connected = "󰂱 {num_connections}";
        format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
        tooltip-format = "{controller_alias}\n{num_connections} connected";
        tooltip-format-connected = "{controller_alias}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click = "blueman-manager";
        interval = 30;
      };

      "custom/paperless" = {
        format = "󱎓";
        tooltip = true;
        tooltip-format = "Paperless";
        on-click = "brave --app=http://mantodea:8026";
      };

      "custom/filemanager" = {
        format = "󰉋";
        tooltip = true;
        tooltip-format = "Files";
        on-click = "nautilus";
      };

      "tray" = {
        spacing = 10;
        icon-size = 18;
      };
    }];

    style = ''
      * {
        font-size: 13px;
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", sans-serif;
        font-weight: bold;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: transparent;
      }

      /* ── Tooltips ─────────────────────────────────────── */
      tooltip {
        background: #${config.colorScheme.palette.base00};
        border: 1px solid #${config.colorScheme.palette.base0E};
        border-radius: 10px;
        color: #${config.colorScheme.palette.base05};
        padding: 4px;
      }
      tooltip label {
        color: #${config.colorScheme.palette.base05};
      }

      /* ── Module groups (pill containers) ─────────────── */
      .modules-left,
      .modules-center,
      .modules-right {
        background: alpha(#${config.colorScheme.palette.base00}, 0.92);
        border: 1px solid alpha(#${config.colorScheme.palette.base0E}, 0.35);
        border-radius: 12px;
        padding: 0 4px;
        margin: 4px 0;
      }

      /* ── Workspaces ───────────────────────────────────── */
      #workspaces {
        padding: 0 4px;
      }
      #workspaces button {
        color: #${config.colorScheme.palette.base04};
        background: transparent;
        padding: 4px 7px;
        margin: 4px 1px;
        border-radius: 8px;
        transition: all 0.15s ease;
        min-width: 18px;
      }
      #workspaces button:hover {
        background: alpha(#${config.colorScheme.palette.base0E}, 0.18);
        color: #${config.colorScheme.palette.base05};
      }
      #workspaces button.active {
        background: #${config.colorScheme.palette.base0E};
        color: #${config.colorScheme.palette.base00};
        min-width: 22px;
      }
      #workspaces button.urgent {
        background: #${config.colorScheme.palette.base08};
        color: #${config.colorScheme.palette.base00};
      }
      #workspaces button.empty {
        color: #${config.colorScheme.palette.base03};
      }

      /* ── Cava ─────────────────────────────────────────── */
      #cava {
        color: #${config.colorScheme.palette.base0E};
        padding: 0 10px 0 4px;
        letter-spacing: 1px;
      }

      /* ── Clock ────────────────────────────────────────── */
      #clock {
        font-weight: bold;
        font-size: 14px;
        color: #${config.colorScheme.palette.base05};
        padding: 0 16px;
        letter-spacing: 0.5px;
      }

      /* ── Disk ─────────────────────────────────────────── */
      #disk {
        color: #${config.colorScheme.palette.base0A};
        padding: 0 10px;
      }

      /* ── Network ──────────────────────────────────────── */
      #network {
        color: #${config.colorScheme.palette.base0B};
        padding: 0 10px;
      }
      #network.disconnected {
        color: #${config.colorScheme.palette.base08};
      }

      /* ── Audio ────────────────────────────────────────── */
      #pulseaudio {
        color: #${config.colorScheme.palette.base09};
        padding: 0 10px;
      }
      #pulseaudio.muted {
        color: #${config.colorScheme.palette.base04};
      }
      #pulseaudio.source-muted {
        color: #${config.colorScheme.palette.base04};
      }

      /* ── Bluetooth ────────────────────────────────────── */
      #bluetooth {
        color: #${config.colorScheme.palette.base0D};
        padding: 0 10px;
      }
      #bluetooth.disabled,
      #bluetooth.off {
        color: #${config.colorScheme.palette.base04};
      }

      /* ── Custom launchers ─────────────────────────────── */
      #custom-filemanager,
      #custom-paperless {
        color: #${config.colorScheme.palette.base0C};
        font-size: 15px;
        padding: 0 10px;
        transition: color 0.15s ease;
      }
      #custom-filemanager:hover,
      #custom-paperless:hover {
        color: #${config.colorScheme.palette.base05};
      }

      /* ── Tray ─────────────────────────────────────────── */
      #tray {
        padding: 0 8px;
      }
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #${config.colorScheme.palette.base08};
        border-radius: 8px;
      }
    '';
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
  # `pidof hyprlock ||` guards against stacking multiple lock instances.
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 630;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
