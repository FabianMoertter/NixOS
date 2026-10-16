{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common.nix
  ];

  nix.settings.trusted-users = [ "root" "fm" ];

  boot.kernelParams = [ "ibt=off" ];

  boot.initrd.luks.devices."luks-39673797-fbb8-406a-8297-60a07b25479d".device =
    "/dev/disk/by-uuid/39673797-fbb8-406a-8297-60a07b25479d";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Networking
  networking.hostName = "hepidoptera";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,de";
    options = "grp:win_space_toggle,caps:escape";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  services.hardware.bolt.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."fm" = {
    isNormalUser = true;
    description = "fm";
    shell = pkgs.zsh;
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys =
      import ../../modules/system/trusted-ssh-keys.nix;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."fabian" = {
    isNormalUser = true;
    description = "fabian";
    shell = pkgs.zsh;
    uid = 1001;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys =
      import ../../modules/system/trusted-ssh-keys.nix;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommend to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "26.05"; # Did you read the comment?

}
