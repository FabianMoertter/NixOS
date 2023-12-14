{ inputs, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack"]; })
  ];


  networking.hostName = "hymenoptera";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.gc.automatic = true;
  nix.gc.dates = "19:00";

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

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.x11 = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  virtualisation = {
    podman = {
      enable = true;
      # Create a 'docker' alias for podman
      dockerCompat = true;
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us,de";
    xkbVariant = "";
    xkbOptions = "caps:none";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  # services.pipewire = {
    # enable = true;
    # alsa.enable = true;
    # alsa.support32Bit = true;
    # pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fabian = {
    isNormalUser = true;
    home = "/home/fabian";
    shell = pkgs.zsh;
    description = "Fabian";
    extraGroups = [ "networkmanager" "wheel" "vboxusers" ];
    packages = with pkgs; [
      #dust
      R
      alacritty
      anki-bin
      bat
      cargo
      slack
      # mendeley
      discord
      dog
      duf
      # eza
      exa
      fd
      figlet
      clang
      firefox
      fzf
      google-chrome
      julia
      lazygit
      lf
      libreoffice
      nodejs
      nvtop
      ripgrep
      rofi
      rustc
      sd
      skypeforlinux
      stow
      terminator
      thunderbird
      xclip
      xh
      zathura
      zellij
      zoxide
      zsh
   #   lutris
    ];
  };

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
      skypeforlinux
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    htop
    tmux
    vim
    wget
    (lutris.override {
       extraPkgs = pkgs: [
         # List package dependencies here
       ];
       extraLibraries = pkgs: [
         wine
         # List library dependencies here
       ];
    })
  ];

  environment.shells = with pkgs; [ zsh ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.zsh.enable = true;

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "22.11"; # Did you read the comment?
}
