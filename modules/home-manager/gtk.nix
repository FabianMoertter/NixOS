{ config, lib, ... }:
{
  gtk.enable = true;

  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";

  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3";

  gtk.iconTheme.package = gruvboxPlus;
  gtk.iconTheme.name = "GruvboxPlus";

  gtk.cursorTheme.package = pkgs.bibata-cursors;
  # basically, same as above
  home.file = {
    ".icons/bibata".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
  };

  # both cases still need you to select theme name declaratively,
  # or imperatively like on other distros
  gtk.cursorTheme.name = "Bibata-Modern-Ice";

}
