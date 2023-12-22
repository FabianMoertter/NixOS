{ pkgs, ... }:
{
  pkgs.hyprland.enable = true;
  nvidiaPatches = true;
  xwayland.enable = true;
}
