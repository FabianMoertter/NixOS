{ config, lib, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [{
      layer = "top";
      position = "top";

      modules-left = [ "custom/chatgpt" "custom/perplexity" "custom/sports" "custom/paperless" ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [ "custom/filemanager" "disk" "network" "pulseaudio" "bluetooth" "clock" "tray" ];

      "hyprland/workspaces" = {
        on-click = "activate";
        active-only = false;
        all-outputs = true;
        format = "{}";
        format-icons = {
          urgent = "";
          active = "";
          default = "";
        };
      };

      "clock" = {
        format = '' {:L%H:%M}'';
        tooltip = true;
        tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
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
    '';
  };
}
