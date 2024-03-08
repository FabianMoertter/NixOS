{ config, lib, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}
