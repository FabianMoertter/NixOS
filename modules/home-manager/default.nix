{
  alacritty = import ./alacritty.nix;
  git = import ./git.nix;
  shell = import ./shell.nix;
  lf = import ./lf.nix;
  neovim = import .nvim/neovim.nix;
  steam = import ./steam.nix;
  tmux = import ./tmux.nix;
  vim = import ./vim.nix;
  zathura = import ./zathura.nix;
}
