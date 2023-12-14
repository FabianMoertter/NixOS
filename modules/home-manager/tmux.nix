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
    '';
    plugins = [ pkgs.tmuxPlugins.vim-tmux-navigator ];
  };
}
