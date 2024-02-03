# See https://github.com/srid/nixos-config/blob/master/home/tmux.nix
{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    # prefix = "C-f";
    baseIndex = 1;
    escapeTime = 100;
    tmuxinator.enable = true;
    # keyMode = "vi";
    # package = "pkgs.tmux-sensible";
    extraConfig = ''
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind - split-window -h
      bind _ split-window -v
      set -g mouse on
      set -g history-limit 10000
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"

      set -g @catppuccin_flavour 'latte' # macchiato, frappe, latte, mocha
      set -g @catppuccin_window_left_separator "█"
      set -g @catppuccin_window_right_separator "█ "
      set -g @catppuccin_window_number_position "right"
      set -g @catppuccin_window_middle_separator "  █"

      set -g @catppuccin_window_default_fill "number"

      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#{pane_current_path}"

      set -g @catppuccin_status_modules_right "application session date_time"
      set -g @catppuccin_status_left_separator  ""
      set -g @catppuccin_status_right_separator " "
      set -g @catppuccin_status_right_separator_inverse "yes"
      set -g @catppuccin_status_fill "all"
      set -g @catppuccin_status_connect_separator "no"
    '';
    plugins = [ 
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.catppuccin
    ];
  };
}
