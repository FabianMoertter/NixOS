{ pkgs, ... }:

{
  home.packages = with pkgs; [
    awww
    codex
    github-copilot-cli
    kdePackages.kate
    kitty
    libreoffice
    quickshell
    waybar
    zotero
  ];

  programs.firefox = {
    enable = true;
    languagePacks = [
      "en-US"
      "de"
    ];

    profiles.default = {
      id = 0;
      isDefault = true;
    };
  };
}
