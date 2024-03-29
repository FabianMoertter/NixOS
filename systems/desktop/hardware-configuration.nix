# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/64857890-4501-4324-8998-057da69e7760";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/33B5-E269";
      fsType = "vfat";
    };

  # SSD
  fileSystems."/data" =
    {
      device = "/dev/disk/by-uuid/bb4fecb4-a4d6-4bfc-9af6-62b2cd144024";
      fsType = "ext4";
    };

  # NVME-2
  fileSystems."/data-2" =
    {
      device = "/dev/disk/by-uuid/9efba5c3-46c5-4fd7-bdb4-1ad56e629a66";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/379d536e-e118-4c82-af1f-863d44797b5c"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp85s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp88s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp86s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
