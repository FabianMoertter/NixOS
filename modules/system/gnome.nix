{ config, lib, pkgs, ... }:
{

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xautolock.time = 30;

  # Exclude GNOME Packages
  environment.gnome.excludePackages = ( with pkgs; [
    gnome-tour 
    gnome-photos
  ]) ++ ( with pkgs.gnome; [
    geary
    hitori
    atomix
    epiphany
    cheese
    gnome-music
    gnome-terminal
    gnome-characters
    gnome-software
    tali
    totem
    iagno
  ]);

}
