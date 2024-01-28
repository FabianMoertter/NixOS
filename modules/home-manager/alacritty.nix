{ pkgs, config, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 14.0;
        # normal = {
          # family = "FiraCode";
          # style = "Regular";
        # };
      };
      window = {
        padding = {
          x = 12;
          y = 12;
        };
        opacity = 0.8;
      };
      env = {
        TERM = "xterm-256color";
      };
      selection.save_to_clipboard = true;
    };
  };
}
