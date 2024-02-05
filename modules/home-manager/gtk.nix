{ config, lib, pkgs, ... }:
{
# {
#   # Configure Cursor Theme
#   home.pointerCursor = {
#     gtk.enable = true;
#     x11.enable = true;
#     package = pkgs.bibata-cursors;
#     name = "Bibata-Modern-Ice";
#     size = 24;
#   };

# Theme GTK
  gtk = {
    enable = true;

    font = {
      name = "Ubuntu";
      size = 12;
      package = pkgs.ubuntu_font_family;
    };

    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";

    iconTheme.package = gruvboxPlus;
    iconTheme.name = "GruvboxPlus";

    gtk.cursorTheme.package = pkgs.bibata-cursors;
    # basically, same as above
    home.file = {
      ".icons/bibata".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
    };

  };
#     theme = {
#       name = "${config.colorScheme.slug}";
#       package = gtkThemeFromScheme {scheme = config.colorScheme;};
#     };
#     iconTheme = {
#       name = "Papirus-Dark";
#       package = pkgs.papirus-icon-theme;
#     };
#     cursorTheme = {
#       name = "Bibata-Modern-Ice";
#       package = pkgs.bibata-cursors;
#     };
#     gtk3.extraConfig = {
#       gtk-application-prefer-dark-theme=1;
#     };
#     gtk4.extraConfig = {
#       gtk-application-prefer-dark-theme=1;
#     };
#   };

  # both cases still need you to select theme name declaratively,
  # or imperatively like on other distros
  gtk.cursorTheme.name = "Bibata-Modern-Ice";
  # QT
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = "adwaita-dark";
    package = pkgs.adwaita-gt;
  };
}
