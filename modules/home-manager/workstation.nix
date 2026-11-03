{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation;
in
{
  options.workstation = {
    repoDirectory = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Projects/NixOS";
      description = "Writable checkout of this configuration.";
    };
    projectsDirectory = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Projects";
      description = "Root searched by the project picker (two directory levels).";
    };
    studyDirectory = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Documents/Learning";
      description = "Writable learning notes and session journals.";
    };
    reducedMotion = lib.mkEnableOption "reduced desktop motion";
  };
  imports = [
    ./actions.nix
    ./ghostty.nix
  ];
}
