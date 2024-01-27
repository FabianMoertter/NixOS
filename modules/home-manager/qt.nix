{ lib, config, ... }:
{
  qt.enable = true;

  # platform theme 'gtk' or 'gnome'
  # qt.platformTheme = 'gtk';

  # name of the qt theme
  # qt.style.name = 'adwaita-dark';

  # detected automatically:
  # adwaita, adwaita-dark, adwaita-highcontrast,
  # adwaita-highcontrastinverse, breeze,
  # bb10bright, bb10dark, cde, cleanlooks,
  # gtk2, motif, plastique

  # package to use
  # qt.style.package = pkgs.adwaita.qt;
}
