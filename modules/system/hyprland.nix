{ config, lib, pkgs, ... }:
{
  pkgs.hyprland.enable = true;
  xwayland.enable = true;
  # nvidiaPatches = true; # not necessary anymore
}
