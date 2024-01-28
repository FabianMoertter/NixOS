{ config, lib, pkgs, ... }:
{
  pkgs.hyprland.enable = true;
  # nvidiaPatches = true; # not necessary anymore
  xwayland.enable = true;
}
