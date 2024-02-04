{ inputs, outputs, lib, config, pkgs, ... }:
{
  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";
    stateVersion = "23.11";
    file = {

      # Test file
      ".config/test/test.yml".text = ''
      test:
        test: test
      '';

      # My neovim config
      ".config/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink ../../modules/home-manager/nvim;
      };

      # Copy kickstart-nvim from Github
      ".config/kickstart/" =  {
          source = builtins.fetchGit {
            url = "https://github.com/nvim-lua/kickstart.nvim";
            rev = "76c5b1ec57f40d17ac787feb018817a802e24bb6";
          };
      };

      # # Copy NvChad from Github ( does not work because read-only )
      # ".config/NvChad/" =  {
      #     source = builtins.fetchGit {
      #       url = "https://github.com/NvChad/Nvchad";
      #       rev = "bb87d70fd6dedce65c67a4390c9faecc55b0ed72";
      #     };
      # };

      # # Copy LazyVim from Github ( does not work because read-only )
      # ".config/LazyVim/" =  {
      #     source = builtins.fetchGit {
      #       url = "https://github.com/LazyVim/starter";
      #       rev = "92b2689e6f11004e65376e84912e61b9e6c58827";
      #     };
      # };

    };
  };

  imports = [
    inputs.nix-colors.homeManagerModules.default
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.kitty
    outputs.homeManagerModules.git
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.lf
    outputs.homeManagerModules.neovim
    outputs.homeManagerModules.qt
    outputs.homeManagerModules.shell
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.vim
    outputs.homeManagerModules.zathura
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  fonts.fontconfig.enable = true;

  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-latte;
  colorScheme = inputs.nix-colors.colorSchemes.dracula;

  programs = with pkgs; {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
    go.enable = true;
  };

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
    # amberol
    # vlc
    # anki-bin
    # poetry
    # pyright
    # haruna
    # rofi
    # sd
    # stow
    # xh
    # mendeley
    R
    jq
    gifsicle
    alacritty
    ansible
    bat
    brave
    btop
    cargo
    clang
    conda
    ctags
    discord
    eza
    fd
    fdupes
    firefox
    glances
    gnumake
    google-chrome
    helix
    julia
    kitty
    lazydocker
    lazygit
    libreoffice
    lua
    luarocks
    mpd
    mpv
    mpvpaper
    ncdu
    nodejs
    nushell
    perl
    python3
    ripgrep
    rstudio
    ruby
    rustc
    skypeforlinux
    slack
    sxhkd
    # swaylock-effects
    terminator
    terraform
    thunderbird
    tree-sitter
    ueberzug
    unzip
    vial
    vscode
    ffmpeg
    wezterm
    xclip
    youtube-dl
    zathura
    zellij
    zig
    zoxide
    wlroots
  ];

  # Default Applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      #"image/pdf" = "firefox.desktop";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

}
