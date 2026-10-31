{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common.nix
    ../../modules/system/gnome.nix
    ../../modules/system/mainUser.nix
    ../../modules/system/nvidia.nix
    ../../modules/system/steam.nix
  ];

  nix.settings.trusted-users = [ "root" "fabian" ];

  # QMK
  hardware.keyboard.qmk.enable = true;

  # prevent sleep
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Networking
  networking.hostName = "lepidoptera";
  # Two Wi-Fi cards joined to the same network broke IPv4 (router replies got
  # lost); keep NetworkManager on wlp86s0 only.
  networking.networkmanager.unmanaged = [ "wlp90s0" ];
  # To use the other card (wlp90s0, AX210) instead, swap the line above for:
  # networking.networkmanager.unmanaged = [ "wlp86s0" ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  virtualisation.docker.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,de";
    variant = "";
    options = "caps:escape";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11"; # Did you read the comment?

}
