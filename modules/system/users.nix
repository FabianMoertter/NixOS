# Module for users other than my own/main user
{ config, pkgs, ...}:
{
  users.users = {

    eva = {
      isNormalUser = true;
      description = "Eva";
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [
        discord
        firefox
        google-chrome
        libreoffice
        skypeforlinux
      ];
    };

    guest = {
      isNormalUser = true;
      description = "Guest";
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [
        discord
        firefox
        google-chrome
        libreoffice
        skypeforlinux
      ];
    };

  };

}
