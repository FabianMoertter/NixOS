{ pkgs, ... }:
{
  home = {

    sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "Hyprland";
    };

    packages = with pkgs; [
      waybar
      swww
      networkmanagerapplet
    ];

  };

  wayland.windowManager.hyprland = {
    enable = true;
    # systemdIntegration = true;
    enableNvidiaPatches = true;

    extraConfig = ''
    '';

    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, A, exec, alacritty"
          "$mod, F, exec, firefox"
          "$mod, S, exec, wofi -show drun -show-icons"
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
