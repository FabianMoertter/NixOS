{ pkgs, ... }:
{
  programs.lf = {
    enable = true;

    settings = {
      preview = true;
      hidden = true;
      drawbox = true;
      icons = false;
    };

    commands = {
      editor-open = ''$$EDITOR $f'';
    };

    keybindings = {
    };

    extraConfig = "";

  };
}
