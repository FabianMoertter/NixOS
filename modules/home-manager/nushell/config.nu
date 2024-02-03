
$env.config = ($env | default {} config).config
$env.config = ($env.config | default {} hooks)
$env.config = ($env.config | update hooks ($env.config.hooks | default [] pre_prompt))
$env.config = ($env.config | update hooks.pre_prompt ($env.config.hooks.pre_prompt | append {
  code: "
    let direnv = (/nix/store/fqz1jxyn6dgxfqq3f8m3zhbcqdlr9laq-direnv-2.32.3/bin/direnv export json | from json)
    let direnv = if not ($direnv | is-empty) { $direnv } else { {} }
    $direnv | load-env
    "
}))

alias .. = cd ../
alias ... = cd ../../
alias c = clear
alias cal = cal -3
alias cat = bat
alias config = cd /home/fabian/Projects/NixOS/nixos-config
alias data = cd /data/home/fabian/
alias delete-generations = sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d
alias dev = nix-shell /home/fabian/Projects/NixOS/nixos-config/shells/python/python.nix
alias hm-update = home-manager switch --flake /home/fabian/Projects/NixOS/nixos-config/
alias ks = exa --group-directories-first
alias l = exa -l --icons --git -a
alias learn = cd /home/fabian/Projects/learning
alias lg = lazygit
alias list-generations = nix profile history --profile /nix/var/nix/profiles/system
alias ll = exa -al --icons
alias ls = exa --group-directories-first
alias lt = exa --tree --level=2 --long --icons --git
alias ltr = exa -lr --icons --sort oldest
alias nixconfig = cd /home/fabian/Projects/NixOS/nixos-config
alias nvim-astro = NVIM_APPNAME=AstroNvim nvim
alias nvim-chad = NVIM_APPNAME=NvChad nvim
alias nvim-fabi = NVIM_APPNAME=FabiVim nvim
alias nvim-kick = NVIM_APPNAME=kickstart nvim
alias nvim-lazy = NVIM_APPNAME=LazyVim nvim
alias nvim-lunar = NVIM_APPNAME=LunarVim nvim
alias ops = cd /home/fabian/Projects/dev-repo
alias perso = cd /home/fabian/Projects/personal_repo
alias tree = exa --tree --icons
alias update = sudo nixos-rebuild switch --flake /home/fabian/Projects/NixOS/nixos-config/ .#
alias vimconfig = cd /home/fabian/Projects/NixOS/nixos-config/modules/home-manager/nvim/
alias wiki = cd /home/fabian/Projects/Neovim/vimwiki