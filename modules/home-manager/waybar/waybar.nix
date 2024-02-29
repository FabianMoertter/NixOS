{ config, lib, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";

      modules-left = [ "clock" "custom/chatgpt" "custom/perplexity" "custom/sports" "custom/paperless" ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [ "custom/keyboard_layout" "custom/filemanager" "disk" "network" "pulseaudio" "bluetooth" "tray" ];

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
        format = "{: %I:%M %p}";
        tooltip = false;
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
      }

      window#waybar {
        background: transparent;
      }

      tooltip {
        background: #141414;
        border-radius: 4px;
      }
    '';
  };
}
