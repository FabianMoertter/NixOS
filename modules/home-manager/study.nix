{ ... }:

{
  programs.anki = {
    enable = true;

    profiles.fm = {
      default = true;
      sync.autoSync = true;
    };
  };
}
