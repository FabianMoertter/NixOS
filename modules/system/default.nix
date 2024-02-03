{
  DNS = import ./DNS/DNS.nix;
  bluetooth = import ./bluetooth.nix;
  bspwm = import ./bspwm.nix;
  gnome = import ./gnome.nix;
  hyprland = import ./hyprland.nix;
  mainUser = import ./mainUser.nix;
  nvidia = import ./nvidia.nix;
  steam = import ./steam.nix;
  users = import ./users.nix;
}
