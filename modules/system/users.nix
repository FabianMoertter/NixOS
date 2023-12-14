{ pkgs, ...}:
{
  users.users.eva = {
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

  users.users.guest = {
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
}
