{ inputs, config, pkgs, ... }:
let
  # The repo is symlinked out of the store so configs stay editable in place.
  repo = "${config.home.homeDirectory}/Projects/NixOS/nixos-config";
in
{
  imports = [
    ../../modules/home-manager/cli.nix
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/kitty/kitty.nix
    ../../modules/home-manager/nvim/neovim.nix
    ../../modules/home-manager/zathura.nix
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-frappe;

  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";
    stateVersion = "23.11";

    file = {
      # My neovim config, kept writable outside the store
      ".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${repo}/modules/home-manager/nvim";
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
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
    nerd-fonts.fira-code
    nerd-fonts.hack
    R
    anki-bin
    appimage-run
    bat
    brave
    cargo
    clang
    ctags
    discord
    eza
    fd
    fdupes
    ffmpeg
    firefox
    gearlever
    ghostty
    gifsicle
    gnumake
    google-chrome
    jq
    kitty
    lazygit
    libreoffice
    lua
    mpv
    ncdu
    nix-tree
    nodejs
    python3
    ripgrep
    rustc
    tcpdump
    teams-for-linux
    thunderbird
    tmux-sessionizer
    tree-sitter
    ueberzugpp
    unzip
    vhs
    vscode
    xclip
    zathura
    zip
    zotero
    zoxide
  ];

  # Default Applications
  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
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
