{
  config,
  lib,
  pkgs,
  ...
}:
let
  study = pkgs.writeShellApplication {
    name = "study";
    runtimeInputs = with pkgs; [
      coreutils
      util-linux
      tmux
      ghostty
      fcitx5
    ];
    text = ''
      export STUDY_DIRECTORY=${lib.escapeShellArg config.workstation.studyDirectory}
    ''
    + builtins.readFile ./scripts/study.sh;
  };
in
{
  home.packages = [
    study
    pkgs.noto-fonts-cjk-sans
  ];
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      config.desktopTheme.fonts.ui.family
      "Noto Sans CJK JP"
    ];
    monospace = [
      config.desktopTheme.fonts.monospace.family
      "Noto Sans Mono CJK JP"
    ];
  };

  # This profile has independent dictionaries, bookmarks, and browser state.
  # Install Yomitan from the linked guide, then import dictionaries and map
  # Anki fields once; those mutable databases are deliberately not overwritten.
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = lib.mkDefault 0;
      isDefault = lib.mkDefault true;
    };
    profiles.learning = {
      id = 1;
      isDefault = false;
      settings = {
        "browser.startup.homepage" = "https://yomitan.wiki/getting-started/";
        "browser.startup.page" = 1;
        "browser.toolbars.bookmarks.visibility" = "always";
      };
    };
  };

  programs.anki = {
    enable = true;
    addons = [ pkgs.ankiAddons.anki-connect ];

    profiles.fm = {
      default = true;
      sync.autoSync = true;
    };
  };
}
