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

    };
  };

  imports = [
    outputs.homeManagerModules.zathura
    outputs.homeManagerModules.shell
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.git
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.vim
    outputs.homeManagerModules.lf
    outputs.homeManagerModules.neovim
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  fonts.fontconfig.enable = true;

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
    # anki-bin
    # helix
    # poetry
    # pyright
    # python3
    # rofi
    # sd
    # stow
    # xh
    R
    alacritty
    bat
    brave
    btop
    cargo
    clang
    conda
    discord
    eza
    fd
    firefox
    fzf
    glances
    gnumake
    google-chrome
    julia
    kitty
    lazydocker
    lazygit
    libreoffice
    lua
    mendeley
    ncdu
    nodejs
    ripgrep
    rstudio
    rustc
    # sd
    sxhkd
    skypeforlinux
    slack
    terminator
    thunderbird
    unzip
    vial
    vscode
    wezterm
    xclip
    youtube-dl
    zathura
    zellij
    zig
    zoxide
  ];

  # Default Applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      #"image/pdf" = "firefox.desktop";
    };
  };

}
