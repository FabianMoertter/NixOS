{ config, pkgs, ... }:

# Impermanence
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  imports =
    [
      ./hardware-configuration.nix
      # Impermanence
      # "${impermanence}/nixos.nix"
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # I don't know what that does
  # nix.settings.auto-optimise-store = true;

  # Cachix (still do not know what it is)
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Garbage Collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # keep some stuff in the store after gc
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  # Nvidia settings
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Nvidia settings
  services.xserver.videoDrivers = [ "nvidia" ];

  # Nvidia settings
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # QMK
  hardware.keyboard.qmk.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # prevent sleep
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  # powerManagement.enable = false;

  # Hostname
  networking.hostName = "lepidoptera";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
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

  fonts.packages = with pkgs; [
    ( nerdfonts.override { fonts = [ "Hack" "FiraCode" ]; })
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude GNOME Packages
  environment.gnome.excludePackages = ( with pkgs; [
    gnome-tour 
  ]) ++ ( with pkgs.gnome; [
    geary
    hitori
    atomix
    epiphany
  ]);

  # BSPWM
  # services.xserver.windowManager.bspwm.enable = true;

  # Docker & Podman
  virtualisation = {
    docker.enable = true;
    # podman = {
    #   enable = true;
    #   # Create a 'docker' alias for podman
    #   dockerCompate = true;
    # };
  };

  # Virtualisation
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxuser.members = [ "user-with-access-to-virtualbox" ];
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.guest.x11 = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us,de";
    xkbVariant = "";
    xkbOptions = "caps:none";
  };

  # keyboard settings still not how I want them
  # xkbOptions = "ctrl:nocaps";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.fabian = {
    isNormalUser = true;
    description = "Fabian";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxuser" ];
    # moved to home-manager
    # only add packages related to desktop environment
    packages = with pkgs; [
      # wofi
    ];
    # add keys here
    openssh.authorizedKeys.keys = [
    ];
  };
  programs.zsh.enable = true; # maybe necessary if zsh default shell

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   git
   htop
   nvtop
   tmux
   vim
   wget
   zsh
   zsh
  ];

  environment.sessionVariables = {
    # XDG
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    #
    EDITOR = "nvim";
    VISUAL = "nvim";
    # Hyprland
    # WLR_NO_HARDWARE_CURSORS = "1";
    # NIXOS_OZONE_WL = "1";
  };

  # Still do not know what xdg Portals are
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Hyprland
  # programs.hyprland = {
    # enable = true;
    # enableNvidiaPatches = true;
    # xwayland.enable = true;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Caching service (should speedup some things)
  services.nscd.enable = true;

  # Postgresql
  # config.services.postgresql = {
    # enable = true;
    # ensureDatabases = [ "mydatabases" ];
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
