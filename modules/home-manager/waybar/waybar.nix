{ config, lib, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";

      modules-left = [ "clock" ];
      modules-center = [ ];
      modules-right = [ "pulseaudio" "blueooth" ];

      "clock" = {
        format = "{: %I:%M %p}";
        tooltip = false;
      };

      "disk" = { };

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


    }];
  };
}
