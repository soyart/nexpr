{ pkgs, hostname, mainUser, ... }:

{
  imports = [
      ./hardware.nix
      ./configuration.nix

      ../../../../defaults/nix
      ../../../../defaults/net

      ../../net
      ../../syspkgs.nix
      ../../main-user.nix
      ../../doas.nix # doas is considered a system setting
      ../../ramdisk.nix
  ];

  networking.hostName = hostname;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = [
      "btusb"
      "bluetooth"
      "uvcvideo"
    ];

    # Use the systemd-boot EFI boot loader.
    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/31e319df-c4fe-48f5-82f5-49c7a5503119";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };

  nexpr = {
    ramDisks = {
      "/tmp" = {
        group = "wheel";
      };
      "/rd" = {
        size = "2G";  
        group = mainUser;
        owner = mainUser;
      };
    };

    mainUser = {
      enable = true;
      username = mainUser;
    };

    doas = {
      enable = true;
      keepSudo = false;
      settings = {
          users = [ mainUser ];
          keepEnv = true;
          persist = true;
      };
    };

    net = {
      iwd.enable = true;
    };

    syspkgs = [
      ../../../../packages/base
      ../../../../packages/devel
      ../../../../packages/net
      ../../../../packages/laptop
      ../../../../packages/nix-extras
    ];
  };

  environment.systemPackages = [
    # Other packages go here
  ];

  programs.nano.enable = false;

  services.automatic-timezoned.enable = true;
}
