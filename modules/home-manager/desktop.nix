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

#    policies.ExtensionSettings = {
#      "446900e4-71c2-419f-a6a7-df9c091e268b" = {
#        installation_mode = "force_installed";
#        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
#      };
#    };

    profiles.default = {
      id = 0;
      isDefault = true;
    };
  };
}
