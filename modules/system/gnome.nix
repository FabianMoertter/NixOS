{ ... }:
{
  # X11 / Wayland session infrastructure
  services.xserver.enable = true;

  # GNOME desktop behind GDM
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
}
