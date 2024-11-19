{ inputs, outputs, lib, config, pkgs, pkgs-unstable, theme, ... }:
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

      # Wallpaper
      "Pictures/Wallpaper/dna-stand-left.jpg" = {
        source = config.lib.file.mkOutOfStoreSymlink ../../assets/wallpaper/dna-strand-left.jpg;
      };

      # Wallpaper
      "Pictures/Wallpaper/dna-stand-right.jpg" = {
        source = config.lib.file.mkOutOfStoreSymlink ../../assets/wallpaper/dna-strand-right.jpg;
      };

      # My neovim config
      ".config/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink ../../modules/home-manager/nvim;
      };

      # Copy kickstart-nvim from Github
      ".config/kickstart/" = {
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

  imports = (with outputs.homeManagerModules; [
    alacritty
    kitty
    git
    hyprland
    lf
    neovim
    qt
    shell
    tmux
    vim
    zathura
  ])
  ++
  (with inputs; [
    nix-colors.homeManagerModules.default
  ]);

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  fonts.fontconfig.enable = true;

  colorScheme = inputs.nix-colors.colorSchemes.${theme};

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

  home.packages = (with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
    # amberol
    anki-bin
    # haruna
    # julia
    # mendeley
    # poetry
    # pyright
    # rofi
    # sd
    # stow
    # swaylock-effects
    # ruff, uv, pedantic
    # sxhkd
    # terminator
    # vlc
    # wezter
    # xh
    # zellij
    # zig
    R
    alacritty
    ansible
    bat
    btop
    # dbeaver-bin
    cargo
    clang
    conda
    ctags
    discord
    eza
    fd
    fdupes
    okular
    ffmpeg
    firefox
    tmux-sessionizer
    gifsicle
    glances
    gnumake
    google-chrome
    helix
    jq
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
    nix-tree
    ruby
    rustc
    skypeforlinux
    slack
    terraform
    awscli2
    thunderbird
    tree-sitter
    ueberzug
    unzip
    vial
    vscode
    wlroots
    xclip
    youtube-dl
    zathura
    zoxide
    zip
  ])
  ++
  (with pkgs-unstable; [
    brave
  ]);

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
