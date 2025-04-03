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
    # dbeaver-bin
    # mendeley
    # poetry
    # rofi
    # ruff, uv, pedantic
    # sd
    # swaylock-effects
    # terminator
    # vlc
    # xh
    # zellij
    # zig
    R
    gearlever
    alacritty
    anki-bin
    tcpdump
    ansible
    awscli2
    bat
    btop
    cargo
    clang
    conda
    ctags
    discord
    teams-for-linux
    eza
    fd
    kubernetes
    minikube
    fdupes
    ffmpeg
    firefox
    ghostty
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
    memos
    mpd
    mpv
    mpvpaper
    ncdu
    nix-tree
    nodejs
    nushell
    okular
    perl
    python3
    ripgrep
    rstudio
    ruby
    rustc
    slack
    standardnotes
    terraform
    thunderbird
    tmux-sessionizer
    tree-sitter
    ueberzug
    unzip
    vial
    vscode
    wlroots
    xclip
    skypeforlinux
    kooha
    devenv
    vhs
    yt-dlp
    zathura
    zip
    zoxide
  ])
  ++
  (with pkgs-unstable; [
    brave
    home-assistant
    ollama
  ]);

  # Default Applications
  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        #"image/pdf" = "firefox.desktop";
      };
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

}
