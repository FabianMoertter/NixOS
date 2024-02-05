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
      color0 = "#${config.colorScheme.palette.base03}";
      color1 = "#${config.colorScheme.palette.base08}";
      color2 = "#${config.colorScheme.palette.base0B}";
      color3 = "#${config.colorScheme.palette.base09}";
      color4 = "#${config.colorScheme.palette.base0D}";
      color5 = "#${config.colorScheme.palette.base0E}";
      color6 = "#${config.colorScheme.palette.base0C}";
      color7 = "#${config.colorScheme.palette.base06}";
      color8 = "#${config.colorScheme.palette.base04}";
      color9 = "#${config.colorScheme.palette.base08}";
      color10 = "#${config.colorScheme.palette.base0B}";
      color11 = "#${config.colorScheme.palette.base0A}";
      color12 = "#${config.colorScheme.palette.base0C}";
      color13 = "#${config.colorScheme.palette.base0E}";
      color14 = "#${config.colorScheme.palette.base0C}";
      color15 = "#${config.colorScheme.palette.base07}";
      color16 = "#${config.colorScheme.palette.base00}";
      color17 = "#${config.colorScheme.palette.base0F}";
      color18 = "#${config.colorScheme.palette.base0B}";
      color19 = "#${config.colorScheme.palette.base09}";
      color20 = "#${config.colorScheme.palette.base0D}";
      color21 = "#${config.colorScheme.palette.base0E}";
      color22 = "#${config.colorScheme.palette.base0C}";
      color23 = "#${config.colorScheme.palette.base06}";
      cursor = "#${config.colorScheme.palette.base07}";
      cursor_text_color = "#${config.colorScheme.palette.base00}";
      selection_foreground = "#${config.colorScheme.palette.base01}";
      selection_background = "#${config.colorScheme.palette.base0D}";
      url_color = "#${config.colorScheme.palette.base0C}";
      active_border_color = "#${config.colorScheme.palette.base04}";
      inactive_border_color = "#${config.colorScheme.palette.base00}";
      bell_border_color = "#${config.colorScheme.palette.base03}";
      tab_bar_style = "fade";
      tab_fade = "1";
      active_tab_foreground  = "#${config.colorScheme.palette.base04}";
      active_tab_background  = "#${config.colorScheme.palette.base00}";
      active_tab_font_style  = "bold";
      inactive_tab_foreground = "#${config.colorScheme.palette.base07}";
      inactive_tab_background = "#${config.colorScheme.palette.base08}";
      inactive_tab_font_style = "bold";
      tab_bar_background = "#${config.colorScheme.palette.base00}";
    };
  };
}
