{ config, lib, ... }:
{
  # Enable BSPWM
  services.xserver.windowManager.bspwm.enable = true;
}
