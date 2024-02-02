{ config, lib, pkgs, ... }:
{
  users.users.fabian = {
    isNormalUser = true;
    description = "Fabian";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxuser" ];
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGS4kNhWQxe9+DtJofug5UDdYtp6JEfsc0tySQ+WvuNa fabian@hymenoptera"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAX6riUhWVDNUyteX4S4sm7JOEsBiMmajfiZ+RHvDLfq fabian.moertter@gmx.net"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLCKNfDPLRpS/1SgCtOv7aSx/x1FPOGfPAeOXc01hjK fabian@mantodea"
    ];
  };
  programs.zsh.enable = true; # maybe necessary if zsh default shell
}
