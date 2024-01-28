{ config, lib, ... }:
{
  users.users.fabian = {
    isNormalUser = true;
    description = "Fabian";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxuser" ];
    packages = with pkgs; [
    ];
    # add keys here
    openssh.authorizedKeys.keys = [
    ];
  };
  programs.zsh.enable = true; # seems necessary if zsh default shell
}
