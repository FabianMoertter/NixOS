{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings.input = {
      kb_layout = "us,de";
      kb_options = "grp:win_space_toggle,caps:escape";
    };
  };
}
