{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Fabian Moertter";
    userEmail = "fabian.moertter@gmx.net";
    aliases = {
      a = "add";
      b = "branch";
      s = "status";
      st = "status";
      l = "log";
    };
    ignores = [
      "*.swp"
    ];
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
