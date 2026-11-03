{ pkgs, ... }:

{
  programs.anki = {
    enable = true;
    addons = [ pkgs.ankiAddons.anki-connect ];

    profiles.fm = {
      default = true;
      sync.autoSync = true;
    };
  };
}
