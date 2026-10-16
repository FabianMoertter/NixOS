# CLI tools: git, shell (bash/zsh), tmux, vim, direnv, devenv

{ config, lib, pkgs, ... }:
let
  myAliases = {
    ".." = "cd ../";
    "..." = "cd ../../";
    c = "clear";

    # eza
    ls = "eza --group-directories-first";
    ltr = "eza -lr --icons --sort oldest";
    l = "eza -l --icons --git -a";
    lt = "eza --tree --level=2 --long --icons --git";
    tree = "eza --tree --icons";
    ll = "eza -al --icons";
    ks = "eza --group-directories-first";

    # bat
    cat = "bat";

    # bsd-utils calendar
    cal = "cal -3";

    # custom aliases for paths
    nixconfig = "cd /home/fabian/Projects/NixOS/nixos-config";
    config = "cd /home/fabian/Projects/NixOS/nixos-config";
    vimconfig = "cd /home/fabian/Projects/NixOS/nixos-config/nvim/";
    wiki = "cd /home/fabian/Projects/Neovim/vimwiki";
    perso = "cd /home/fabian/Projects/personal_repo";
    ops = "cd /home/fabian/Projects/dev-repo";
    learn = "cd /home/fabian/Projects/learning";
    data = "cd /data/home/fabian/";
    web = "cd /data/home/fabian/Projects/fabian-moertter.github.io";

    # NixOS
    update = "sudo nixos-rebuild switch --flake /home/fabian/Projects/NixOS/nixos-config/ .#";
    hm-update = "home-manager switch --flake /home/fabian/Projects/NixOS/nixos-config/";
    list-generations = "nix profile history --profile /nix/var/nix/profiles/system";
    delete-generations = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d";

    # dev shells
    go_init = "nix flake init --template 'https://flakehub.com/f/the-nix-way/dev-templates/*#go'";
    python_init = "nix flake init --template 'https://flakehub.com/f/the-nix-way/dev-templates/*#python'";

    # Neovim config switcher
    nvim-kick = "NVIM_APPNAME=kickstart nvim";
    nvim-fabi = "NVIM_APPNAME=FabiVim nvim";

    # lazygit
    lg = "lazygit";
  };
in
{
  programs.git = {
    enable = true;
    ignores = [
      "*.swp"
      "*.direnv"
    ];
    settings = {
      user = {
        name = "Fabian Moertter";
        email = "fabian.moertter@gmx.net";
      };
      alias = {
        a = "add";
        b = "branch";
        s = "status";
        st = "status";
        l = "log";
      };
      init.defaultBranch = "main";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    # dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    dirHashes = {
      "Docs" = "$HOME/Documents";
      "Videos" = "$HOME/Videos";
      "dl" = "$HOME/Downloads";
      "Projects" = "$HOME/Projects";
      "config" = "$HOME/Projects/NixOS/nixos-config";
      "vim" = "$HOME/Projects/NixOS/nixos-config/nvim";
      "perso" = "$HOME/Projects/personal_repo/";
    };

    history = {
      save = 10000;
      size = 10000;
      path = "$HOME/.cache/zsh_history";
    };

    defaultKeymap = "viins";

    shellAliases = myAliases;

    initContent = lib.mkOrder 1000 ''
      # Load OpenAI credentials only for the lifetime of one command instead
      # of exporting them into every interactive shell and all its children.
      with-openai-env() {
        local env_file="$HOME/.config/chatgpt.env"
        local env_mode

        if [[ $# -eq 0 ]]; then
          print -u2 "usage: with-openai-env <command> [args...]"
          return 2
        fi

        if [[ ! -r "$env_file" ]]; then
          print -u2 "with-openai-env: cannot read $env_file"
          return 1
        fi

        env_mode="$(${lib.getExe' pkgs.coreutils "stat"} -c '%a' "$env_file")" || return 1
        if (( (8#$env_mode & 8#077) != 0 )); then
          print -u2 "with-openai-env: refusing insecure permissions $env_mode on $env_file (expected 600 or stricter)"
          return 1
        fi

        (
          set -a
          source "$env_file"
          set +a
          command "$@"
        )
      }

      # Add ssh key from .config
      ssh-add $HOME/.config/.ssh/id_ed25519 2> /dev/null

      # nix-direnv less verbose output
      export DIRENV_LOG_FORMAT=
      export DIRENV_WARN_TIMEOUT=1m

      # set options
      setopt sharehistory
      setopt histignorealldups
      setopt sh_nullcmd
      setopt interactivecomments
      setopt notify
      setopt rcexpandparam
      setopt nocheckjobs
      setopt promptsubst
      setopt nobeep
      setopt appendhistory
      setopt auto_pushd
      setopt pushd_ignore_dups
      setopt pushdminus

      # set aliases for file types
      alias -s log=nvim
      alias -s html=nvim
      alias -s text=nvim
      alias -s csv=nvim
      alias -s py=nvim
      alias -s nix=nvim
      alias -s pdf=zathura

      # speed up completion
      zstyle ':completion:*' accept-exact '*(N)'
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path $HOME/.cache/zcache
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./.;
        file = "p10k.zsh";
      }
    ];
  };

  # See https://github.com/srid/nixos-config/blob/master/home/tmux.nix
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 100;
    tmuxinator.enable = true;
    extraConfig = ''
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind - split-window -h
      bind _ split-window -v
      set -g mouse on
      set -g history-limit 10000
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"

      set-option -g status-position top

      set -g @catppuccin_flavor 'frappe'
    '';
    plugins = [
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.catppuccin
    ];
  };

  programs.eza.enable = true;
  programs.bat.enable = true;
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  home.packages = with pkgs; [
    claude-code
    codex
    devenv
    fd
    jq
    lazygit
    luarocks
    ripgrep
    wget
  ];

}
