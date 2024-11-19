{ config, lib, pkgs, theme, outputs, ... }:
{

  home = {

    # sessionVariables = {
    #   XDG_CURRENT_DESKTOP = "Hyprland";
    #   XDG_SESSION_DESKTOP = "Hyprland";
    #   XDG_SESSION_TYPE = "Hyprland";
    # };

    packages = with pkgs; [
      libnotify
      # pywal
      # wofi
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

  # services.mako = {
  #   enable = true;
  #   backgroundColor = "#${config.colorScheme.colors.base01}";
  #   borderColor = "#${config.colorScheme.colors.base0E}";
  #   borderRadius = 5;
  #   borderSize = 2;
  #   textColor = "#${config.colorScheme.colors.base04}";
  #   layer = "overlay";
  # };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # systemdIntegration = true;
    # enableNvidiaPatches = true;

    # TODO get rid of absolute paths
    # extraConfig = ''
    # exec-once = swww init
    # exec-once = swww img -o DP-1 /home/fabian/Projects/NixOS/nixos-config/assets/wallpaper/dna-strand-left.jpg
    # exec-once = swww img -o DP-2 /home/fabian/Projects/NixOS/nixos-config/assets/wallpaper/dna-strand-right.jpg
    # '';
    # exec-once = swww img -o DP-1 /home/fabian/Pictures/Wallpaper/tiger-left.jpg
    # exec-once = swww img -o DP-2 /home/fabian/Pictures/Wallpaper/tiger-right.jpg

    settings = {

      input = {
        kb_layout = "us,de";
        kb_variant = ",qwerty";
        kb_options = "caps:escape,grp:alt_shift_toggle";
      };

      exec-once = [
        # "kitty tmux new -s home"
        # "thunderbird"
        "killall waybar"
        "sleep 0.5"
        "waybar -c $HOME/.config/waybar/config"
        "swww init"
        # "swww img -o DP-2 /home/fabian/Projects/NixOS/nixos-config/assets/wallpaper/dna-strand-left.jpg"
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
        drop_shadow = false;
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
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

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, M, exit,"
        "$mod, F, exec, firefox"
        "$mod, S, exec, rofi -show drun -show-icons"
        "$mod, G, togglegroup"
        "$mod, X, killactive"
        "$mod, A, fullscreen"
        "$mod, 1, focusmonitor, DP-2"
        "$mod, 2, focusmonitor, DP-1"
        "$mod, 3, focusmonitor, DP-2"
        "$mod, 4, focusmonitor, DP-1"
        "$mod, 5, focusmonitor, DP-2"
        "$mod, 6, focusmonitor, DP-1"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
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
