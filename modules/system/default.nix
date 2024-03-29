{
  DNS = import ./DNS/DNS.nix; # does not work
  bluetooth = import ./bluetooth.nix;
  bspwm = import ./bspwm.nix;
  gnome = import ./gnome.nix;
  homeServer = import ./homeServer.nix;
  hyprland = import ./hyprland.nix;
  mainUser = import ./mainUser.nix;
  nvidia = import ./nvidia.nix;
  salt = import ./salt.nix; # SaltStack
  steam = import ./steam.nix;
  users = import ./users.nix;
  virtualization = import ./virtualization.nix;
}
