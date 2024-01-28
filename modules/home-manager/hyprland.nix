{ config, lib, pkgs, ... }:
{

  # pkgs.hyprland.enable = true;
  # nvidiaPatches = true;
  # xwayland.enable = true;

  home = {

    # sessionVariables = {
    #   XDG_CURRENT_DESKTOP = "Hyprland";
    #   XDG_SESSION_DESKTOP = "Hyprland";
    #   XDG_SESSION_TYPE = "Hyprland";
    # };

    packages = with pkgs; [
      waybar
      # wofi
      rofi-wayland
      mako
      # swaync
      libnotify
      swww
      networkmanagerapplet
      grim
    ];

  };

  wayland.windowManager.hyprland = {
    enable = true;
      xwayland.enable = true;
    # systemdIntegration = true;
    # enableNvidiaPatches = true;

    # TODO get rid of absolute paths
    extraConfig = ''
      exec-once = swww init
      exec-once = swww img -o DP-1 /home/fabian/Pictures/Wallpaper/tiger-left.jpg
      exec-once = swww img -o DP-2 /home/fabian/Pictures/Wallpaper/tiger-right.jpg
    '';

    settings = {

      input = {
        kb_layout = "us";
        kb_options = "caps:escape";
      };

      exec-once = {
      };

      decoration = {
        rounding = 10;
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
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

      "$mod" = "SUPER";

      bindm = [
      # mouse movements
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
      ];

      bind = [
          "$mod, Return, exec, alacritty"
          "$mod, M, exit,"
          "$mod, F, exec, firefox"
          "$mod, S, exec, rofi -show drun -show-icons"
      ]
      ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
      );
    };

  };
}
