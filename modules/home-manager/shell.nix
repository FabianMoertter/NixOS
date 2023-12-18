# Configure bash and zsh in this file
# Inspired by
# https://gitlab.com/librephoenix/nixos-config/-/blob/main/user/shell/sh.nix?ref_type=heads

{ pkgs, ... }:
  let
    myAliases = {
      ".." = "cd ../";
      "..." = "cd ../../";
      c = "clear";

      # ls ( use exa instead )
      # ls = "ls --color=auto --group-directories-first";
      # ll = "ls -al";
      # ltr = "ls -ltr";
      # ks = "ls";

      # exa
      ls = "exa --group-directories-first";
      ltr = "exa -lr --icons --sort oldest";
      l = "exa -l --icons --git -a";
      lt = "exa --tree --level=2 --long --icons --git";
      tree = "exa --tree --icons";
      ll = "exa -al --icons";
      ks = "exa --group-directories-first";

      # bat
      cat = "bat";

      # bsd-utils calendar
      cal = "cal -3";

      # custom aliases for paths
      dev = "nix-shell /home/fabian/Projects/NixOS/nixos-config/shells/python/python.nix";
      nixconfig = "cd /home/fabian/Projects/NixOS/nixos-config";
      config = "cd /home/fabian/Projects/NixOS/nixos-config";
      vimconfig = "cd /home/fabian/Projects/NixOS/nixos-config/modules/home-manager/nvim/";
      wiki = "cd /home/fabian/Projects/Neovim/vimwiki";
      perso = "cd /home/fabian/Projects/personal_repo";
      learn = "cd /home/fabian/Projects/learning";
      data = "cd /data/home/fabian/";

      #NixOS functions
      update = "sudo nixos-rebuild switch --flake /home/fabian/Projects/NixOS/nixos-config/ .#";
      # update home-manager
      update-hm = "home-manager switch --flake /home/fabian/Projects/NixOS/nixos-config/";
      # list generations
      list-generations = "nix profile history --profile /nix/var/nix/profiles/system";
      # delete generations ( add days as variable )
      delete-generations = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d";

      # Neovim
      nvim-lazy = "NVIM_APPNAME=LazyVim nvim";
      nvim-kick = "NVIM_APPNAME=kickstart nvim";
      nvim-chad = "NVIM_APPNAME=NvChad nvim";
      nvim-astro = "NVIM_APPNAME=AstroNvim nvim";
      nvim-lunar = "NVIM_APPNAME=LunarVim nvim";
      nvim-fabi = "NVIM_APPNAME=FabiVim nvim";
    };
  in
  {

    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = myAliases;
    };

    programs.zsh = {
      enable = true;
      autocd = true;
      cdpath = [
      ];
      dotDir = ".config/zsh";
      enableCompletion = true;
      enableAutosuggestions = true;
      dirHashes = {
        "Docs" = "$HOME/Documents";
        "Videos" = "$HOME/Videos";
        "dl" = "$HOME/Downloads";
	"Projects" = "$HOME/Projects";
        "config" = "$HOME/Projects/NixOS/nixos-config";
        "vim" = "$HOME/Projects/NixOS/nixos-config/modules/home-manager/nvim";
        "perso" = "$HOME/Projects/personal_repo/";
      };

      history = {
        save = 10000;
        size = 10000;
        path = "$HOME/.cache/zsh_history";
      };

      defaultKeymap = "viins";

      shellAliases = myAliases;

      # Similar to [](#opt-programs.zsh.shellAliases),
      # but are substituted anywhere on a line.
      shellGlobalAliases = {};

      sessionVariables = {
      };

      # Exta commands added to .zshrc
      initExtra = ''
        # OpenAI KEY (ChatGPT etc)
        source $HOME/.config/chatgpt.env

        # Add ssh key from .config
        ssh-add $HOME/.config/.ssh/id_ed25519 2> /dev/null

        # nix-direnv less verbose output
        export DIRENV_LOG_FORMAT=

        # set options
        setopt sharehistory
        setopt histignorealldups
        setopt sh_nullcmd
        setopt extendedglob
        setopt interactivecomments
        setopt notify
        setopt nocaseglob
        setopt rcexpandparam
        setopt nocheckjobs
        setopt promptsubst
        setopt numericglobsort
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

        # autoload -Uz compinit
        # compinit

        zstyle ':completions:*' auto-description 'specify: %d'
        zstyle ':completions:*' completer_expand_complete_correct_approximate
        zstyle ':completions:*' format 'Completing %d'
        zstyle ':completions:*' rehash true
        zstyle ':completions:*' group-name ""
        zstyle ':completions:*' menu select=2
        # eval "$(dircolors -b)"
        # zstyle ':completions:*default' list-colors %{(s.:.)LS_COLORS}
        zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'
        zstyle ':completions:*' list-colors ""
        zstyle ':completions:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
        zstyle ':completions:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z} l:|=* r:|*'
        zstyle ':completions*:descriptions' format '%U%F{cyan}%d%f%u'
        zstyle ':completions:*' select-prompt '%SScrolling active: current selection at %p%s'
        zstyle ':completions:*' use-comptctl false
        zstyle ':completions:*' verbose true
        zstyle ':completions:*:*kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
        zstyle ':completions:*:*kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

        # speed up completion
        zstyle ':completion:*' accept-exact '*(N)'
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path $HOME/.cache/zcache

        # Change cursor shape for different vi modes
        # function zle-keymap-select {
          # if [[ {KEYMAP} == vicmd ]] ||
            # [[ $1 = 'beam' ]]; then
            # echo -ne '\e[5 q'
          # elif [[ {KEYMAP} == main ]] ||
            # [[ {KEYMAP} == viins ]] ||
            # [[ {KEYMAP} == "" ]] ||
            # [[ $1 = 'block' ]]; then
            # echo -ne '\e[1 q'
          # fi
        # zle -N zle-keymap-select
        # zle-line-init() {
          # zle -K viins
          # echo -ne "\e[1 q"
        # }
        # zle -N zle-line-init
        # echo -ne '\e[5 q'
        # preexec() { echo -ne '\e[1 q' ;}

        # vi command line
        # autoload -U edit-command-line
        # zle -N edit-command-line; zle -N edit-command-line
        # bindkey '^e' edit-command-line

        # bindkey '^R' history-incremental-pattern-search-backward

        # Neovim Config Switcher
        # https://www.youtube.com/watch?v=LkHjJlSgKZY&t=131s
        # functions
        # function nvims() {
        #   items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")
        #   config=$(printf "%s\n" "$items['at']" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
        #   if [[ -z $config ]]; then
        #       echo "Nothing selected"
        #       return 0
        #   elif [[ $config == "default" ]]; then
        #     config = ""
        #   fi
        #   NVIM_APPNAME=$config nvim $@
        # }

        # bindkey -s ^n "nvims\n"

      '';

      # Exta commands added to .zshenv
      envExtra = ''
      '';

      # Exta commands added to .zprofile
      profileExtra = ''
      '';

      localVariables = {
      };

      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.4.0";
            sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.7.1";
            sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
          };
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
	{
	  name = "powerlevel10k-config";
	  src = ./zsh;
	  file = "p10k.zsh";
	}
      ];
    };
  }
