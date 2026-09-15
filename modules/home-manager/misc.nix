{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
    go.enable = true;

    zathura = {
      enable = true;
      extraConfig = ''
        set sandbox none
        set statusbar-h-padding 0
        set statusbar-v-padding 0
        set page-padding 1
        set selection-clipboard clipboard
        map u scroll half-up
        map d scroll half-down
        map D toggle_page_mode
        map r reload
        map R rotate
        map K zoom in
        map J zoom out
        map i recolor
        map p print
        map g goto top
      '';
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
    R
    appimage-run
    bat
    brave
    cargo
    clang
    ctags
    discord
    fdupes
    ffmpeg
    firefox
    gearlever
    ghostty
    gifsicle
    gnumake
    google-chrome
    libreoffice
    lua
    mpv
    ncdu
    nix-tree
    nodejs
    python3
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
