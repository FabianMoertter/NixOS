{ pkgs, config, nix-colors, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        foreground = "#${config.colorScheme.palette.base05}";
        background = "#${config.colorScheme.palette.base00}";
      };
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
