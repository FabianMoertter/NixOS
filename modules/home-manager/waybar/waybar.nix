{ config, lib, pkgs, ... }:
{
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
        on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
        on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
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
}
