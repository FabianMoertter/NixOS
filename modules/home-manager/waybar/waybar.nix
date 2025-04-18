{ config, lib, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [{
      layer = "top";
      position = "top";

      modules-left = [ "hyprland/workspaces" "cava" ];
      # modules-center = [ "idle_inhibitor" "clock" ];
      # modules-center = [ "clock" "custom/notification" ];
      modules-center = [ "clock" ];


      # modules-left = [ "custom/chatgpt" "custom/perplexity" "custom/sports" "custom/paperless" ];
      # modules-center = [ "hyprland/workspaces" ];
      modules-right = [ "custom/paperless" "custom/filemanager" "disk" "network" "pulseaudio" "bluetooth" "tray" ];

      # "hyprland/workspaces" = {
      #   on-click = "activate";
      #   active-only = false;
      #   all-outputs = true;
      #   format = "{}";
      #   format-icons = {
      #     urgent = "";
      #     active = "";
      #     default = "";
      #   };
      # };
      #

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        active-only = false;
        on-click = "activate";
        persistent-workspaces = {
          "*" = [ 1 2 3 4 5 6 7 8 ];
        };
      };

      "custom/startmenu" = {
        tooltip = false;
        format = "";
        # exec = "rofi -show drun";
        on-click = "sleep 0.1 && rofi-launcher";
      };

      "clock" = {
        format = "{:%a %d %b %R}";
        # format = '' {:L%H:%M}'';
        # format = "{:%R 󰃭 %d·%m·%y}";
        tooltip = true;
        format-alt = "{:%I:%M %p}";
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      "disk" = {
        interval = 600;
        format = "  {percentage_used}%";
        tooltip-format = "{used} used out of {total} on {path} ";
        on_click = "alacritty -e htop";
      };

      "bluetooth" = {
        format = " {status}";
        format-disabled = " {status}";
        format-connected = " {num_connections}";
        tooltip-format = "{device_alias}";
        format-connected-battery = " {device_alias} {device_battery_percentage}%";
        tooltip-format-enumerate-connected = "{device_alias}";
        format-off = "";
        interval = 30;
        on-click = "blueman-manager";
      };

      "cava" = {
        hide_on_silence = false;
        framerate = 60;
        bars = 10;
        format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        input_delay = 1;
        # "noise_reduction" = 0.77;
        sleep_timer = 5;
        bar_delimiter = 0;
      };

      "pulseaudio" = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };

      "tray" = {
        spacing = 12;
      };

      "hyprland/language" = {
        format-en = "🇺🇸";
        format-de = "🇩🇪";
        min-length = 5;
        tooltip = false;
      };

      "network" = {
        format-disconnected = "Disconnected";
        format-wifi = " {essid}";
        tooltip-format = " {signalStrength}";
        on-click = "wifimenu";
      };

      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = "{capacity}%";
        format-alt = "{time} {icon}";
        format-full = " {capacity}%";
        format-icons = [ "" "" "" ];
      };

      "custom/dashboard" = {
        format = "🤖";
        on-click = "brave --app=mantodea:8004";
      };

      "custom/anytype" = {
        format = "🤖";
        on-click = "true";
      };

      "custom/sports" = {
        format = "🏋️";
        on-click = "brave --app=https://calimove.com";
      };

      "custom/chatgpt" = {
        format = "🤖";
        on-click = "brave --app=https://chat.openai.com";
      };

      "custom/perplexity" = {
        format = "🤖";
        on-click = "brave --app=https://perplexity.ai";
      };

      "custom/paperless" = {
        format = "📄";
        on-click = "brave --app=http://mantodea:8026";
      };

      "custom/filemanager" = {
        format = "";
        on-click = "nautilus";
        tooltip = false;
      };

      "custom/keyboard_layout" = {
        format = "🎹 {}";
        on-click = "";
        exec = "";
      };
    }];

    style = ''
      * {
        font-size: 16px;
        font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
        font-weight: bold;
        color: #f3f9ff;
        border-radius: 0px;
        border: none;
        min-height: 0px;
      }

      window#waybar {
        background: transparent;
      }

      #cava {
        color: @pink;
      }

      tooltip {
        background: #${config.colorScheme.palette.base00};
        border: 1px solid #${config.colorScheme.palette.base05};
        border-radius: 12px;
      }
      tooltip label {
        color: #${config.colorScheme.palette.base05};
      }
      #clock {
        font-weight: bold;
        padding: 0px 10px;
        color: #${config.colorScheme.palette.base00};
        background: #${config.colorScheme.palette.base0E};
      }
      .modules-left {
        background: #${config.colorScheme.palette.base00};
        border: 1px solid #${config.colorScheme.palette.base0E};
        padding-right: 15px;
        padding-left: 2px;
        border-radius: 10px;
      }
      .modules-center {
        background: #${config.colorScheme.palette.base00};
        border: 1px solid #${config.colorScheme.palette.base0E};
        padding-right: 5px;
        padding-left: 5px;
        border-radius: 10px;
      }
      .modules-right {
        background: #${config.colorScheme.palette.base00};
        border: 1px solid #${config.colorScheme.palette.base0E};
        padding-right: 15px;
        padding-left: 15px;
        border-radius: 10px;
      }
    '';
  };
}
