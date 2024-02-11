{
  alacritty = import ./alacritty.nix;
  git = import ./git.nix;
  hyprland = import ./hyprland.nix;
  kitty = import ./kitty/kitty.nix;
  lf = import ./lf.nix;
  mpd = import ./mpd.nix;
  neovim = import ./nvim/neovim.nix;
  qt = import ./qt.nix;
  shell = import ./shell.nix;
  steam = import ./steam.nix;
  swaync = import ./swaynotificationcenter.nix;
  tmux = import ./tmux.nix;
  vim = import ./vim.nix;
  waybar = import ./waybar/waybar.nix;
  zathura = import ./zathura.nix;
}
