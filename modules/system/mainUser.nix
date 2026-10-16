{ pkgs, ... }:
{
  users.users.fabian = {
    isNormalUser = true;
    description = "Fabian";
    shell = pkgs.zsh;
    homeMode = "700";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxuser" "libvirtd" ];
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = import ./trusted-ssh-keys.nix;
  };
}
