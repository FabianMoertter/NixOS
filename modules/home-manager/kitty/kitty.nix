{ pkgs, config, nix-colors, ... }:
{
  programs.kitty = {
    enable = true;
    font.name = "JetBrainMono Nerd Font";
    font.size = 14;
    settings = {
      foreground = "#${config.colorScheme.palette.base05}";
      background = "#${config.colorScheme.palette.base00}";
      background_opacity = "0.8";
      color0 = "#${config.colorScheme.colors.base03}";
      color1 = "#${config.colorScheme.colors.base08}";
      color2 = "#${config.colorScheme.colors.base0B}";
      color3 = "#${config.colorScheme.colors.base09}";
      color4 = "#${config.colorScheme.colors.base0D}";
      color5 = "#${config.colorScheme.colors.base0E}";
      color6 = "#${config.colorScheme.colors.base0C}";
      color7 = "#${config.colorScheme.colors.base06}";
      color8 = "#${config.colorScheme.colors.base04}";
      color9 = "#${config.colorScheme.colors.base08}";
      color10 = "#${config.colorScheme.colors.base0B}";
      color11 = "#${config.colorScheme.colors.base0A}";
      color12 = "#${config.colorScheme.colors.base0C}";
      color13 = "#${config.colorScheme.colors.base0E}";
      color14 = "#${config.colorScheme.colors.base0C}";
      color15 = "#${config.colorScheme.colors.base07}";
      color16 = "#${config.colorScheme.colors.base00}";
      color17 = "#${config.colorScheme.colors.base0F}";
      color18 = "#${config.colorScheme.colors.base0B}";
      color19 = "#${config.colorScheme.colors.base09}";
      color20 = "#${config.colorScheme.colors.base0D}";
      color21 = "#${config.colorScheme.colors.base0E}";
      color22 = "#${config.colorScheme.colors.base0C}";
      color23 = "#${config.colorScheme.colors.base06}";
      cursor = "#${config.colorScheme.colors.base07}";
    };
  };
}
