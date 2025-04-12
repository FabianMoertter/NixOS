{ config, lib, pkgs, theme, outputs, ... }:
{

  home = {

    packages = with pkgs; [
      libnotify
      # pywal
      mpvpaper
      cava
      font-awesome
      grim
      hyprpicker
      networkmanagerapplet
      rofi-wayland
      slurp
      swaylock
      swaynotificationcenter
      swww
      pavucontrol
    ];

  };

  imports = [
    outputs.homeManagerModules.waybar
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    extraConfig = ''
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = NIXPKGS_ALLOW_UNFREE,1
    '';

    settings = {

      input = {
        kb_layout = "us,de";
        kb_variant = ",qwerty";
        kb_options = "caps:escape,grp:alt_shift_toggle";
      };

      exec-once = [
        # "kitty tmux new -s home"
        "killall waybar"
        "sleep 0.5"
        "waybar -c $HOME/.config/waybar/config"
        "swww init"
        "swww img -o DP-2 /home/fabian/Projects/NixOS/nixos-config/assets/wallpaper/dna-strand-left.jpg"
        "swww img -o DP-1 /home/fabian/Projects/NixOS/nixos-config/assets/wallpaper/dna-strand-right.jpg"
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
        "float, anki"
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
        "$mod, G, togglegroup"
        "$mod, X, killactive"
        "$mod, A, fullscreen"
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
}
