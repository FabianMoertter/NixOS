{ config, ... }:
let
  inherit (config.colorScheme) palette;
in
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = config.desktopTheme.fonts.monospace.family;
      font-size = config.desktopTheme.fonts.monospace.size;
      background = palette.base00;
      foreground = palette.base05;
      cursor-color = palette.base05;
      cursor-text = palette.base00;
      selection-background = palette.base02;
      selection-foreground = palette.base05;
      palette = [
        "0=#${palette.base00}"
        "1=#${palette.base08}"
        "2=#${palette.base0B}"
        "3=#${palette.base0A}"
        "4=#${palette.base0D}"
        "5=#${palette.base0E}"
        "6=#${palette.base0C}"
        "7=#${palette.base05}"
        "8=#${palette.base03}"
        "9=#${palette.base08}"
        "10=#${palette.base0B}"
        "11=#${palette.base0A}"
        "12=#${palette.base0D}"
        "13=#${palette.base0E}"
        "14=#${palette.base0C}"
        "15=#${palette.base07}"
      ];
      window-padding-x = 12;
      window-padding-y = 10;
      cursor-style-blink = !config.workstation.reducedMotion;
      # tmux owns panes and sessions; Ghostty supplies the terminal surface.
      shell-integration-features = "no-cursor";
    };
  };
}
