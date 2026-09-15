{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/audio.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/hyprland.nix
    # ../../modules/system/mainUser.nix
    # ../../modules/system/kde.nix
  ];


  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" "fm" ];
    keep-outputs = true;
    keep-derivations = true;
  };

  # Garbage Collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "ibt=off" ];

  boot.initrd.luks.devices."luks-39673797-fbb8-406a-8297-60a07b25479d".device =
    "/dev/disk/by-uuid/39673797-fbb8-406a-8297-60a07b25479d";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Networking
  networking.hostName = "hepidoptera";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

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
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  services.printing.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gparted
    htop
    tmux
    vim
    wget
    zsh
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;

  services.openssh.enable = true;

  services.flatpak.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommend to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "26.05"; # Did you read the comment?

}
