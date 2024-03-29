# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f5913f2e-1b06-4413-b03f-4201a6e194c3";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd:6" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/f5913f2e-1b06-4413-b03f-4201a6e194c3";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd:6" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/f5913f2e-1b06-4413-b03f-4201a6e194c3";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd:6" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7CB3-65EB";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/86114262-1471-4b76-8149-f0966a1668c3"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
