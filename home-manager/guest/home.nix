{ inputs, outputs, lib, config, pkgs, ... }:
{
  home = {
    username = "guest";
    homeDirectory = "/home/guest";
    stateVersion = "23.11";
  };
}
